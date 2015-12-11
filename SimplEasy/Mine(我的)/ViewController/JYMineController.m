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
#import "IMDefine.h"
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
    self.title = @"我的";
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

#pragma mark *** 私有方法 ***
//登录刷新
-(void)login{
   [self.tableView reloadData];
}
/** 配置sectionFooterView，第一个section */
- (UIView *)sectionFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 50)];
    footerView.backgroundColor = [UIColor lightGrayColor];
    footerView.backgroundColor = [UIColor whiteColor];
    NSArray *labelNames = @[@"39",@"12",@"84"];
    NSArray *btnNames = @[@"闲置",@"需求",@"易友"];
    for (int i = 0; i < 3; i++) {
        
        UILabel *label = [UILabel new];
        [footerView addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.text = labelNames[i];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*kWindowW/3);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(footerView.mas_centerY);
            make.width.mas_equalTo(kWindowW/3);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:JYGlobalBg forState:UIControlStateHighlighted];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*kWindowW/3);
            make.top.mas_equalTo(footerView.mas_centerY);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kWindowW/3);
        }];
    }
    return footerView;
}

/** 跳转到设置界面 */
- (void)jumpToSetting{
    JYSettingViewController *setVC = [[JYSettingViewController alloc] init];
    setVC.title = @"设置";
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
    
    
}
#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [@[@1,@3,@2][section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JYSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSellerCell"];
        
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
//        self.headPhoto = [UIImage scaleToSize:self.headPhoto size:CGSizeMake(60, 60)];
//        self.headPhoto = [UIImage circleImageWithImage:self.headPhoto borderWidth:0.5 borderColor:[UIColor whiteColor]];
        
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
        }
        cell.nickNameLb.text = nickname;
        cell.schoolLb.text = [NSString stringWithFormat:@"简介:%@",signature];
        cell.schoolLb.textColor = [UIColor darkGrayColor];
        cell.rankIV.image = [UIImage imageNamed:@"grade"];
        cell.followBtn.hidden = YES;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        return cell;
    }else{
        JYNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
        if (!cell) {
            cell = [[JYNormalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MineCell"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.section == 1) {
            if (indexPath.row == 1) {
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
            cell.textLabel.text = @[@"正在交易",@"我的易友",@"简易等级"][indexPath.row];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return [self sectionFooterView];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0?80:45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?0:10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
