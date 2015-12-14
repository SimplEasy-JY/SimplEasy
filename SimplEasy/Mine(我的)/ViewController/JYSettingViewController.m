//
//  JYSettingViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/13.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYSettingViewController.h"
#import "JYLoginViewController.h"
#import "JYFileManager.h"
#import "JYRootViewController.h"

//IMSDK Headers
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMMyself+CustomUserInfo.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMSDK+Nickname.h"

#define cachePath [kLibraryPath stringByAppendingPathComponent:@"Caches"]
@interface JYSettingViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,getter=isLogouting)BOOL isLogouting;
@property(strong,nonatomic) MBProgressHUD *hud;
@end

@implementation JYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self configBottomBtn];
    [JYFactory addBackItemToVC:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:IMLogoutNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)configBottomBtn{
    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOutBtn setTitle:[JYRootViewController shareRootVC].isLogin?@"退出登陆":@"登录" forState:UIControlStateNormal];
    [self.view addSubview:logOutBtn];
    [logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logOutBtn setBackgroundColor:JYGlobalBg];
    [logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(45);
    }];
    [logOutBtn addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [@[@1,@3,@3][section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    cell.textLabel.text = @[@[@"切换学校"],@[@"通知",@"隐私与安全",@"通用设置"],@[@"清理缓存",@"意见反馈",@"关于简易"]][indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = @"浙江传媒大学";
        cell.detailTextLabel.textColor = kRGBColor(109, 194, 241);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.textLabel.mas_centerY);
            make.left.mas_equalTo(cell.textLabel.mas_right).mas_equalTo(10);
        }];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[[JYFileManager defaultManager] folderSizeAtPath:cachePath]];
            
        }else if(indexPath.row == 2){
            cell.detailTextLabel.text = @"New";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.layer.cornerRadius = 7.5;
            cell.detailTextLabel.textColor = JYGlobalBg;
            //            [cell.detailTextLabel setValue:[UIColor redColor] forKey:@"backgroundColor"];
            [cell setValue:[UIColor redColor] forKeyPath:@"detailTextLabel.backgroundColor"];
            [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.textLabel.mas_centerY);
                make.left.mas_equalTo(cell.textLabel.mas_right).mas_equalTo(10);
                make.height.mas_equalTo(15);
            }];
        }
    }
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

//kRemoveCellSeparator
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //清除缓存操作
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认要清楚缓存么？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *successNotice = [NSString stringWithFormat:@"清除了%.2fM的缓存",[[JYFileManager defaultManager] folderSizeAtPath:cachePath]];
                [[JYFileManager defaultManager] clearCacheAtPath:cachePath];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除成功" message:successNotice preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tableView;
}

#pragma mark -响应方法

-(void)loginOut:(UIButton *)sender{
    if (self.isLogouting) {
        return;
    }
    
    self.isLogouting = YES;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，也不会收到任何推送消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
    [actionSheet showFromTabBar:[self tabBarController].tabBar];
    
    
}
#pragma mark - actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if (buttonIndex == 0) {
        
        if (self.hud) {
            [self.hud hide:YES];
            [self.hud removeFromSuperview];
            self.hud = nil;
        }
        self.hud = [[MBProgressHUD alloc] initWithView:[[self tabBarController] view]];
        
        [[[self tabBarController] view] addSubview:self.hud];
        [self.hud setLabelText:@"正在注销..."];
        [self.hud show:YES];
        
        [g_pIMMyself logout];
        [[JYFileManager defaultManager] clearCacheAtPath:cachePath];
        //注册注销通知
        [[NSNotificationCenter defaultCenter] postNotificationName:IMLogoutNotification object:nil];
        
        
    } else {
        self.isLogouting = NO;
    }
}

- (void)didLogout {
    [_hud hide:YES];
    [_hud removeFromSuperview];
    _hud = nil;
}
@end
