//
//  JYMineController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYMineController.h"
#import "JYSellerCell.h"
#import "JYUserInfoViewController.h"
#import "JYSettingViewController.h"
#import "UIImage+Circle.h"
#import "IMContactViewController.h"
#import "JYNormalCell.h"
#import "JYUserPublishItemCell.h"
#import "IMDefine.h"
#import "JYRootViewController.h"
#import "JYUserNeedsVC.h"

//#import "IMMyselfInfoViewController.h"
//#import "IMSettingTableViewCell.h"
//#import "IMModifyPasswordViewController.h"
//#import "IMBlackListViewController.h"
//#import "IMVersionInformationViewController.h"
//#import "IMUserDialogViewController.h"

#import "MBProgressHUD.h"

//IMSDK Headers
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMMyself+CustomUserInfo.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMSDK+Nickname.h"

@interface JYMineController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property(strong,nonatomic)UIImage *headPhoto;
@property(nonatomic,getter=isLogouting)BOOL isLogouting;

@property(strong,nonatomic) MBProgressHUD *hud;

@end

@implementation JYMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    _titleLabel.text = @"我的";
    /** 添加naviRightItem */
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(jumpToSetting)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    [self.tableView registerClass:[JYSellerCell class] forCellReuseIdentifier:@"JYSellerCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:IMCustomUserInfoDidInitializeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:IMReloadMainPhotoNotification object:nil];
    //监听登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:IMLoginNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark *** 私有方法 ***
//登录刷新
-(void)login{
   [self.tableView reloadData];
}

/** 跳转到设置界面 */
- (void)jumpToSetting{
    JYSettingViewController *setVC = [[JYSettingViewController alloc] init];
    setVC.title = @"设置";
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
    
    
}

- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning TODO --> 跳转到登录界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/** 跳转到用户需求界面 */
- (void)showUserNeedsVC{
    if (![JYRootViewController shareRootVC].isLogin) {
        [self showAlert];
    }else{
        JYUserNeedsVC *vc = [JYUserNeedsVC new];
        vc.title = @"我的需求";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)configHeadPhoto{
    //头像
    self.headPhoto = [g_pIMSDK mainPhotoOfUser:[g_pIMMyself customUserID]];
    if (!self.headPhoto) {
        [g_pIMSDK requestMainPhotoOfUser:[g_pIMMyself customUserID]
                                 success:^(UIImage *mainPhoto) {
                                     NSLog(@"request main photo success: %@",mainPhoto);
                                 }
                                 failure:^(NSString *error) {
                                     NSLog(@"request main photo failed for %@",error);
                                 }];
    }
    if (self.headPhoto == nil) {
        NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:[g_pIMMyself customUserID]];
        
        NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
        NSString *sex = nil;
        
        if ([customInfoArray count] > 0) {
            sex = [customInfoArray objectAtIndex:0];
        }
        
        if ([sex isEqualToString:@"女"]) {
            self.headPhoto = [UIImage imageNamed:@"IM_head_female.png"];
        } else {
            self.headPhoto = [UIImage imageNamed:@"IM_head_male.png"];
        }
    }
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [@[@2,@3,@2][section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JYSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSellerCell"];
            if (![JYRootViewController shareRootVC].isLogin) {
                cell.headIV.image = [UIImage imageNamed:@"IM_head_male"];
                cell.schoolLb.text = @"简介:";
                cell.nickNameLb.text = @"未登录";
            }else{
                [self configHeadPhoto];
                cell.headIV.image =self.headPhoto;
                //昵称
                NSString *nickname = [g_pIMSDK nicknameOfUser:[g_pIMMyself customUserID]];
                
                if ([nickname length] == 0) {
                    nickname = [g_pIMMyself customUserID];
                }
                //获取个性签名
                NSString *customUserInfo = [g_pIMMyself customUserInfo];
                NSArray *customInfoArray = [customUserInfo componentsSeparatedByString:@"\n"];
                NSString *signature = nil;
                if ([customInfoArray count] > 1) {
                    signature = [customInfoArray objectAtIndex:0];
                    cell.schoolLb.text = [NSString stringWithFormat:@"简介:%@",signature];
                } else {
                    cell.schoolLb.text = @" ";
                }
                cell.nickNameLb.text = nickname;
            }
            cell.schoolLb.textColor = [UIColor darkGrayColor];
            cell.followBtn.hidden = YES;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
            return cell;
        }else {
            JYUserPublishItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYUserPublishItemCell"];
            cell.idleNum.text = [JYRootViewController shareRootVC].isLogin?@"18":@"0";
            cell.needsNum.text = [JYRootViewController shareRootVC].isLogin?@"20":@"0";
            [cell addNeedsTarget:self selector:@selector(showUserNeedsVC) forControlEvents:UIControlEventTouchUpInside];
//            [cell.needsBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
//            [cell.needsBtn bk_addEventHandler:^(id sender) {
//                if (![JYRootViewController shareRootVC].isLogin) {
//                    [self showAlert];
//                }else{
//                    JYUserNeedsVC *vc = [JYUserNeedsVC new];
//                    vc.title = @"我的需求";
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//            } forControlEvents:UIControlEventTouchUpInside];
            
            cell.friendNum.text = [JYRootViewController shareRootVC].isLogin?@"88":@"0";
            return cell;
        }
    }else{
        JYNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
        if (cell == nil) {
            cell = [[JYNormalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MineCell"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.section == 1) {
            if ([JYRootViewController shareRootVC].isLogin) {
                if (indexPath.row == 2) {
                    cell.detailTextLabel.text = @"发布30条闲置";
                    [cell.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.textLabel.mas_right).mas_equalTo(10);
                        make.centerY.mas_equalTo(cell.textLabel.mas_centerY);
                    }];
                    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
                    [cell setBadge:0];
                }else{
                    [cell setBadge:1];
                }
            }
            cell.textLabel.text = @[@"正在交易",@"新的易友",@"简易等级"][indexPath.row];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.imageView.image = @[[UIImage imageNamed:@"trading"],[UIImage imageNamed:@"newfriend"],[UIImage imageNamed:@"grade2"]][indexPath.row];
        }
        if (indexPath.section == 2) {
            cell.textLabel.text = @[@"我的收藏",@"草稿箱"][indexPath.row];
            cell.imageView.image = @[[UIImage imageNamed:@"collection"],[UIImage imageNamed:@"draught"]][indexPath.row];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        }
        return cell;
    }
}

#pragma mark *** <UITableViewDelegate> ***

kRemoveCellSeparator

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section == 0 && indexPath.row == 0)?80:45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?0:10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![JYRootViewController shareRootVC].isLogin) {
        [self showAlert];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        JYUserInfoViewController *userInfoVC = [[JYUserInfoViewController alloc] init];
        userInfoVC.title = @"个人信息";
        userInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1){
        IMContactViewController *contactVC = [[IMContactViewController alloc]init];
        contactVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contactVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_tableView registerClass:[JYSellerCell class] forCellReuseIdentifier:@"JYSellerCell"];
//        [_tableView registerClass:[JYNormalCell class] forCellReuseIdentifier:@"MineCell"];
        [_tableView registerClass:[JYUserPublishItemCell class] forCellReuseIdentifier:@"JYUserPublishItemCell"];
    }
    return _tableView;
}

- (NSArray *)dataArr {
    if(_dataArr == nil) {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
}


#pragma mark - notification

- (void)reloadData:(NSNotification *)notification {
    if (![notification.object isEqual:[g_pIMMyself customUserID]]) {
        return;
    }
    
    [_tableView reloadData];
}

#pragma mark -kvo

@end
