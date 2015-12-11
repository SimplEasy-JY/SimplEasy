//
//  JYMessageController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYMessageController.h"

#import "IMUserDialogViewController.h"
#import "IMDefine.h"
#import "IMGroupDialogViewController.h"
#import "IMUserInformationViewController.h"
#import "IMMyself+RecentContacts.h"

//IMSDK Headers
#import "IMRecentContactsView.h"
#import "IMMyself+RecentContacts.h"
#import "IMMyself+Relationship.h"
#import "IMRecentGroupsView.h"
#import "IMMyself+Group.h"
#import "IMMyself+RecentGroups.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMSDK+MainPhoto.h"
#import "IMSDK+CustomerService.h"
#import "IMSDK+Nickname.h"
static CGFloat rowHeight = 60;
@interface JYMessageController () <UITableViewDelegate,UITableViewDataSource,IMRecentContactsViewDelegate, IMRecentContactsViewDatasource, UIAlertViewDelegate, IMRecentGroupsViewDatasource, IMRecentGroupsViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYMessageController{
    IMRecentContactsView *_recentContactsView;
    IMRecentGroupsView *_recentGroupsView;
    
    UIBarButtonItem *_rightBarButtonItem;
    
    NSString *_selectedCustomUserID;
    BOOL _showGroupMessage;
    BOOL _alertClicked;
}
- (void)dealloc
{
    [_recentContactsView setDelegate:nil];
    [_recentContactsView setDataSource:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"消息"];
        [_titleLabel setText:@"消息"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"tab_news.png"]];
        [[self tabBarItem] setSelectedImage:[UIImage imageNamed:@"tab_news_.png"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:IMLoginStatusChangedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMGroupListDidInitializeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMRelationshipDidInitializeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReceiveUserMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMUnReadMessageChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 设置navigationItem的rightBBI */
//    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"群消息" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
//    self.navigationItem.rightBarButtonItem = rightBBI;
    // Do any additional setup after loading the view.
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"群消息" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    [_rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(6, 191, 4) forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    _recentContactsView = [[IMRecentContactsView alloc] initWithFrame:CGRectMake(0, rowHeight*3, kWindowW, kWindowH -rowHeight*3 - 114)];
    
    [_recentContactsView setDataSource:self];
    [_recentContactsView setDelegate:self];
    [self.tableView addSubview:_recentContactsView];
    
    _recentGroupsView = [[IMRecentGroupsView alloc] initWithFrame:[_recentContactsView frame]];
    
    [_recentGroupsView setDataSource:self];
    [_recentGroupsView setDelegate:self] ;
    [[self view] addSubview:_recentGroupsView];
    [_recentGroupsView setHidden:YES];
//    /** 为了调用tableView的懒加载 */
//    self.tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Msgcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    cell.imageView.image = @[[UIImage imageNamed:@"message_07"],[UIImage imageNamed:@"message_13"],[UIImage imageNamed:@"message_15"]][indexPath.row];
    cell.textLabel.text = @[@"系统消息",@"评论",@"陌生人消息"][indexPath.row];
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

kRemoveCellSeparator
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark *** LazyLoading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
	}
	return _tableView;
}


- (void)rightBarButtonItemClick:(id)sender {
    if (sender != _rightBarButtonItem) {
        return;
    }
    
    _showGroupMessage = !_showGroupMessage;
    
    if (!_showGroupMessage) {
        [_rightBarButtonItem setTitle:@"群消息"];
        [_recentGroupsView setHidden:YES];
        [_recentContactsView setHidden:NO];
    } else {
        [_rightBarButtonItem setTitle:@"个人消息"];
        [_recentGroupsView setHidden:NO];
        [_recentContactsView setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkLoginStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkLoginStatus {
    switch ([g_pIMMyself loginStatus]) {
        case IMMyselfLoginStatusLogined:
        {
            [_titleLabel setText:@"消息"];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
            break;
        case IMMyselfLoginStatusLogouting:
        {
            [_titleLabel setText:@"正在注销..."];
        }
            break;
        case IMMyselfLoginStatusNone:
        {
            [_titleLabel setText:@"消息(未连接)"];
        }
            break;
        case IMMyselfLoginStatusAutoLogining:
        case IMMyselfLoginStatusLogining:
        {
            [_titleLabel setText:@"连接中..."];
        }
            break;
        case IMMyselfLoginStatusReconnecting:
        {
            [_titleLabel setText:@"正在重连..."];
        }
            break;
        default:
            break;
    }
    
    [_recentContactsView reloadData];
    [_recentGroupsView reloadData];
    [self setBadge];
}

- (void)setBadge {
    NSInteger unreadCount = [g_pIMMyself unreadChatMessageCount] + [g_pIMMyself unreadGroupChatMessageCount];
    
    if (unreadCount) {
        [[self tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)unreadCount]];
    } else {
        [[self tabBarItem] setBadgeValue:nil];
    }
}


#pragma mark - IMRecentContactView delegate

- (NSString *)recentContactsView:(IMRecentContactsView *)recentContactsView titleForIndex:(NSInteger)index {
    NSString *customUserID = [[g_pIMMyself recentContacts] objectAtIndex:index];
    
    if ([customUserID hasPrefix:@"kefu_"]) {
        if ([customUserID isEqualToString:@"kefu_104695"]) {
            return @"客服";
        }
        
        IMServiceInfo *info = [g_pIMSDK serviceInfoWithCustomUserID:customUserID];
        
        if (info.serviceName) {
            return info.serviceName;
        } else {
            [g_pIMSDK requestServiceInfoWithCustomUserID:customUserID success:^(IMServiceInfo *serviceInfo) {
                [_recentContactsView reloadData];
            } failure:^(NSString *error) {
                
            }];
        }
    }
    
    NSString * nickName = [g_pIMSDK nicknameOfUser:customUserID];
    
    if (nickName) {
        return nickName;
    }
    return customUserID;
}

- (UIImage *)recentContactsView:(IMRecentContactsView *)recentContactsView imageForIndex:(NSInteger)index {
    NSString *customUserID = [[g_pIMMyself recentContacts] objectAtIndex:index];
    
    UIImage *image = [g_pIMSDK mainPhotoOfUser:customUserID];
    
    if (image == nil) {
        NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:customUserID];
        
        NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
        NSString *sex = nil;
        
        if ([customInfoArray count] > 0) {
            sex = [customInfoArray objectAtIndex:0];
        }
        
        if ([sex isEqualToString:@"女"]) {
            image = [UIImage imageNamed:@"IM_head_female.png"];
        } else {
            image = [UIImage imageNamed:@"IM_head_male.png"];
        }
    }
    
    return image;
}

- (void)recentContactsView:(IMRecentContactsView *)recentContactView didSelectRowWithCustomUserID:(NSString *)customUserID {
    for (UIViewController *controller in [[self navigationController] viewControllers]) {
        if ([controller isKindOfClass:[IMUserDialogViewController class]]) {
            return;
        }
    }
    
    _selectedCustomUserID = customUserID;
    
    if ([customUserID hasPrefix:@"kefu_"]) {
        [g_pIMMyself clearUnreadChatMessageWithUser:customUserID];
        [self setBadge];
        
        IMUserDialogViewController *controller = [[IMUserDialogViewController alloc] init];
        
        IMServiceInfo *info = [g_pIMSDK serviceInfoWithCustomUserID:customUserID];
        
        if ([customUserID isEqualToString:@"kefu_104695"]) {
            [controller setTitle:@"客服"];
        } else {
            [controller setTitle:info.serviceName];
        }
        [controller setIsCustomerSevice:YES];
        [controller setCustomUserID:customUserID];
        [controller setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:controller animated:YES];
        
        return;
    }
    
    if (![g_pIMMyself isMyFriend:customUserID] && ![[g_pIMMyself customUserID] isEqualToString:customUserID]) {
        //if is not friend, enter information controller
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你们还不是好友，需要先加他为好友" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertView setTag:1000];
        [alertView show];
        return;
    }
    
    [g_pIMMyself clearUnreadChatMessageWithUser:customUserID];
    [self setBadge];
    
    IMUserDialogViewController *controller = [[IMUserDialogViewController alloc] init];
    
    [controller setCustomUserID:customUserID];
    [controller setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)recentContactsView:(IMRecentContactsView *)recentContactView didDeleteRowWithCustomUserID:(NSString *)customUserID {
    [self reloadData];
}


#pragma mark - IMRecentGroupsView delegate

- (void)recentGroupsView:(IMRecentGroupsView *)recentGroupsView didSelectRowWithGroupID:(NSString *)groupID {
    for (UIViewController *controller in [[self navigationController] viewControllers]) {
        if ([controller isKindOfClass:[IMGroupDialogViewController class]]) {
            return;
        }
    }
    
    if (![g_pIMMyself isMyGroup:groupID]) {
        //if is not friend, enter information controller
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你不是群成员，或你已经被移出该群" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertView show];
        return;
    }
    
    [g_pIMMyself clearUnreadGroupChatMessageWithGroupID:groupID];
    [self setBadge];
    
    IMGroupDialogViewController *controller = [[IMGroupDialogViewController alloc] init];
    
    [controller setGroupID:groupID];
    [controller setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)recentGroupsView:(IMRecentGroupsView *)recentGroupsView didDeleteRowWithGroupID:(NSString *)groupID {
    [self reloadData];
}


#pragma mark - alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_alertClicked) {
        return;
    }
    
    if ([alertView tag] == 1000) {
        
        _alertClicked = YES;
        
        IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
        
        [controller setCustomUserID:_selectedCustomUserID];
        [controller setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:controller animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    _alertClicked = NO;
}



#pragma mark - notification

- (void)loginStatusChanged:(NSNotification *)notification {
    [self checkLoginStatus];
}

- (void)reloadData {
    [self checkLoginStatus];
}


@end
