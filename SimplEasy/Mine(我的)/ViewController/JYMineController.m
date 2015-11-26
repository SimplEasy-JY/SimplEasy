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
@property(nonatomic,getter=isLogouting)BOOL isLogouting;

@property(strong,nonatomic) MBProgressHUD *hud;

@end

@implementation JYMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    /** 添加naviRightItem */
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(jumpToSetting)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    [self.tableView registerClass:[JYSellerCell class] forCellReuseIdentifier:@"JYSellerCell"];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:IMLogoutNotification object:nil];
}

#pragma mark *** 私有方法 ***

/** 配置sectionFooterView，第一个section */
- (UIView *)sectionFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 50)];
    NSArray *labelNames = @[@"39",@"12",@"84"];
    NSArray *btnNames = @[@"闲置",@"需求",@"易友"];
    for (int i = 0; i < 3; i++) {
        
        UILabel *label = [UILabel new];
        [footerView addSubview:label];
        label.text = labelNames[i];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*kWindowW/3);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(footerView.mas_centerY);
            make.width.mas_equalTo(kWindowW/3);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    return [@[@1,@2,@2][section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JYSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSellerCell"];
        
        //头像
        UIImage *headPhoto = [g_pIMSDK mainPhotoOfUser:[g_pIMMyself customUserID]];
        
        if (headPhoto == nil) {
            NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:[g_pIMMyself customUserID]];
            
            NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
            NSString *sex = nil;
            
            if ([customInfoArray count] > 0) {
                sex = [customInfoArray objectAtIndex:0];
            }
            
            if ([sex isEqualToString:@"女"]) {
                headPhoto = [UIImage imageNamed:@"IM_head_female.png"];
            } else {
                headPhoto = [UIImage imageNamed:@"IM_head_male.png"];
            }
            
        }
        headPhoto = [UIImage scaleToSize:headPhoto size:CGSizeMake(60, 60)];
        headPhoto = [UIImage circleImageWithImage:headPhoto borderWidth:0.5 borderColor:[UIColor whiteColor]];

        cell.headIV.image =headPhoto;
        //昵称
        NSString *nickname = [g_pIMSDK nicknameOfUser:[g_pIMMyself customUserID]];
        
        if ([nickname length] == 0) {
            nickname = [g_pIMMyself customUserID];
        }
        cell.nickNameLb.text = nickname;
        cell.schoolLb.text = @"简介：我是收藏的好玩家";
        cell.schoolLb.textColor = [UIColor darkGrayColor];
        cell.rankIV.image = [UIImage imageNamed:@"grade"];
        cell.followBtn.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MineCell"];
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
            }
            cell.textLabel.text = @[@"新的易友",@"简易等级"][indexPath.row];
            cell.imageView.image = @[[UIImage imageNamed:@"newfriend"],[UIImage imageNamed:@"grade2"]][indexPath.row];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point"]];
        }
        if (indexPath.section == 2) {
            cell.textLabel.text = @[@"我的收藏",@"草稿箱"][indexPath.row];
            cell.imageView.image = @[[UIImage imageNamed:@"collection"],[UIImage imageNamed:@"draught"]][indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    return 10;
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



@end
