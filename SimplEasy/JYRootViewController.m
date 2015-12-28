//
//  IMRootViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "JYRootViewController.h"
#import "JYCircleViewController.h"
#import "JYHomeController.h"
#import "JYMessageController.h"
#import "JYMineController.h"
#import "JYClassifyViewController.h"
#import "JYAroundViewController.h"

//#import "IMConversationViewController.h"
//#import "IMContactViewController.h"
//#import "IMAroundViewController.h"
//#import "IMSettingViewController.h"
#import "JYLoginViewController.h"
#import "IMDefine.h"
#import <AudioToolbox/AudioToolbox.h>
#import "JYSDKManager.h"

//thrid party
#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMMyself.h"
#import "IMMyself+CustomMessage.h"
#import "IMMyself+Relationship.h"
#import "IMMyself+Group.h"
#import "IMMyself+CustomUserInfo.h"

#define IM_CONVERSATION_TAG 1
#define IM_CONTACT_TAG 2
#define IM_AROUND_TAG 3
#define IM_SETTING_TAG 4

static JYRootViewController *rootViewC = nil;// 定义全局静态变量

@interface IMExtraAlertView : UIAlertView

@property (nonatomic, strong) NSObject *extraData;

@end

@implementation IMExtraAlertView

@end

@interface JYRootViewController ()<UITabBarControllerDelegate, IMRelationshipDelegate, IMMyselfDelegate, IMCustomUserInfoDelegate, IMGroupDelegate>

- (void)logout;

@property(strong,nonatomic)CYLTabBarController *tabBarController;

@end

@implementation JYRootViewController{
//    UITabBarController *_tabBarController;
    UINavigationController *_contactNav;
    UINavigationController *_conversationNav;
    UINavigationController *_aroundNav;
    UINavigationController *_settingNav;
    
    JYLoginViewController *_loginController;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

#pragma mark - 单例
// 重写alloc 方法封堵创建方法(调用alloc方法时 默认会走allocWithZone这个方法 所以只需封堵allocWithZone 方法即可)
+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (!rootViewC) {
        rootViewC = [super allocWithZone:zone];//如果没有实例让父类去创建一个
        return rootViewC;
    }
    return nil;
}
+ (JYRootViewController *)shareRootVC  //定义一个类方法进行访问(便利构造)
{
    if (!rootViewC) {
        rootViewC = [[JYRootViewController alloc]init];// 如果实例不存在进行创建
    }
    return rootViewC;
  
}

// 封堵深复制 （copy 和 mutablecopy 都可以实现深复制 但他们最终都需要调用copyWithZone方法所以直接封堵它）
- (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [g_pIMMyself setDelegate:nil];
    [g_pIMMyself setRelationshipDelegate:nil];
    [g_pIMMyself setGroupDelegate:nil];
    [g_pIMMyself setCustomUserInfoDelegate:nil];
}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//       
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self navigationController] setNavigationBarHidden:YES];
    
    self.isLogin = NO;
    
    //设置IMMyself 代理
    [g_pIMMyself setDelegate:self];
    [g_pIMMyself setRelationshipDelegate:self];
    [g_pIMMyself setGroupDelegate:self];
    [g_pIMMyself setCustomUserInfoDelegate:self];
//    [self setupViewControllers];
    [self addChildViewController:self.sideMenu];
    [self.view addSubview:self.sideMenu.view];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:IMLogoutNotification object:nil];

    

}



/** 设置侧拉框 */
- (RESideMenu *)sideMenu{
    if (!_sideMenu) {
         [self setupViewControllers];
        _sideMenu=[[RESideMenu alloc]initWithContentViewController:self.tabBarController leftMenuViewController:[JYClassifyViewController new] rightMenuViewController:nil];
        /** 让侧拉框不能通过手势调出，解决每个tabBar都会调出侧拉框的问题 */
        _sideMenu.panGestureEnabled = NO;
        /** 可以让出现菜单时不显示状态栏 */
        _sideMenu.menuPrefersStatusBarHidden = YES;
        /** 关闭透视，视差效果 */
        _sideMenu.parallaxEnabled = NO;
        _sideMenu.contentViewInPortraitOffsetCenterX = 80;
        _sideMenu.contentViewScaleValue = 1.0f;
    }
    return _sideMenu;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)logout {
    self.isLogin = NO;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMLoginCustomUserID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMLoginPassword];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMLoginTEL];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMLoginUID];

    [[NSUserDefaults standardUserDefaults] synchronize];
    [self addChildViewController:loginVC];
    [self.view addSubview:loginVC.view];
    
//    [self removeFromParentViewController];
//    [[self view] removeFromSuperview];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)receiveNewUserMessage:(NSString *)customUserID {
    if (![[g_pIMSDKManager recentChatObjects] containsObject:customUserID]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSNumber *sound = [userDefault objectForKey:[NSString stringWithFormat:@"sound:%@",[g_pIMMyself customUserID]]];
        
        if (!sound) {
            sound = [NSNumber numberWithBool:YES];
            [userDefault setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"sound:%@",[g_pIMMyself customUserID]]];
            [userDefault synchronize];
        }
        
        if ([sound boolValue]) {
            AudioServicesPlayAlertSound(1015);
        }
        
        NSNumber *shake = [userDefault objectForKey:[NSString stringWithFormat:@"shake:%@",[g_pIMMyself customUserID]]];
        
        if (!shake) {
            shake = [NSNumber numberWithBool:YES];
            [userDefault setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"shake:%@",[g_pIMMyself customUserID]]];
            [userDefault synchronize];
        }
        
        if ([shake boolValue]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IMReceiveUserMessageNotification object:nil];
    }
}

- (void)receiveNewGroupMessage:(NSString *)groupID {
    if (![[g_pIMSDKManager recentChatObjects] containsObject:groupID]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSNumber *sound = [userDefault objectForKey:[NSString stringWithFormat:@"sound:%@",[g_pIMMyself customUserID]]];
        
        if (!sound) {
            sound = [NSNumber numberWithBool:YES];
            [userDefault setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"sound:%@",[g_pIMMyself customUserID]]];
            [userDefault synchronize];
        }
        
        if ([sound boolValue]) {
            AudioServicesPlayAlertSound(1015);
        }
        
        NSNumber *shake = [userDefault objectForKey:[NSString stringWithFormat:@"shake:%@",[g_pIMMyself customUserID]]];
        
        if (!shake) {
            shake = [NSNumber numberWithBool:YES];
            [userDefault setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"shake:%@",[g_pIMMyself customUserID]]];
            [userDefault synchronize];
        }
        
        if ([shake boolValue]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:IMReceiveUserMessageNotification object:nil];
    }
}


#pragma mark - IMMyself delegate
- (void)loginFailedWithError:(NSString *)error {
    if ([[error uppercaseString] isEqualToString:@"LOGIN CONFLICT"] || [[error uppercaseString] isEqualToString:@"WRONG PASSWORD"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的帐号在别处登陆,请确认是否本人操作" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        
        [alert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IMLogoutNotification object:nil];
    }
}

- (void)didLogoutFor:(NSString *)reason {
    if ([[reason uppercaseString] isEqualToString:@"USER LOGOUT"] || [[reason uppercaseString] isEqualToString:@"LOGIN CONFLICT"] || [g_pIMMyself customUserID] == nil) {
        if ([[reason uppercaseString] isEqualToString:@"LOGIN CONFLICT"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的帐号在别处登陆,请确认是否本人操作" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            
            [alert show];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:IMLogoutNotification object:nil];
        return;
    }
    
}
//登录成功回调，包括注册自动登录
- (void)didLogin:(BOOL)autoLogin {
    self.isLogin = YES;
    //发送登陆成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:IMLoginNotification object:nil];
    
}
- (void)logoutFailedWithError:(NSString *)error {
    //注销deviceToken 失败也要退回到登陆界面
    [[NSNotificationCenter defaultCenter] postNotificationName:IMLogoutNotification object:nil];
}

- (void)loginStatusDidUpdateForOldStatus:(IMMyselfLoginStatus)oldStatus newStatus:(IMMyselfLoginStatus)newStatus {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMLoginStatusChangedNotification object:nil];
}

- (void)didReceiveText:(NSString *)text fromCustomUserID:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    [self receiveNewUserMessage:customUserID];
}

- (void)didReceiveAudioData:(NSData *)data fromCustomUserID:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    [self receiveNewUserMessage:customUserID];
}

- (void)didReceivePhoto:(UIImage *)photo fromCustomUserID:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    [self receiveNewUserMessage:customUserID];
}

- (void)failedToSendText:(NSString *)text toGroup:(NSString *)groupID clientSendTime:(UInt32)timeIntervalSince1970 error:(NSString *)error {
    if ([error isEqualToString:@"Too frequently"]) {
        _notifyText = @"消息发送太快啦，休息一下吧";
        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
        
        [self displayNotifyHUD];
    }
}

- (void)failedToSendText:(NSString *)text toUser:(NSString *)customUserID clientSendTime:(UInt32)timeIntervalSince1970 error:(NSString *)error {
    if ([error isEqualToString:@"Too frequently"]) {
        _notifyText = @"消息发送太快啦，休息一下吧";
        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
        
        [self displayNotifyHUD];
    }
}


#pragma mark - IMMyself custom userinfo delegate

- (void)customUserInfoDidInitialize {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMCustomUserInfoDidInitializeNotification object:nil];
}


#pragma mark - IMMyself group delegate

- (void)groupListDidInitialize {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMGroupListDidInitializeNotification object:nil];
}

- (void)addedToGroup:(NSString *)groupID byUser:(NSString *)customUserID {
    if ([customUserID isEqualToString:[g_pIMMyself customUserID]]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
}

- (void)removedFromGroup:(NSString *)groupID byUser:(NSString *)customUserID {
    if ([customUserID isEqualToString:[g_pIMMyself customUserID]]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:IMRemovedGroupNotification(groupID) object:nil];
}

- (void)group:(NSString *)groupID deletedByUser:(NSString *)customUserID {
    if ([customUserID isEqualToString:[g_pIMMyself customUserID]]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:IMDeleteGroupNotification(groupID) object:nil];
}

- (void)didCreateGroupWithName:(NSString *)groupName groupID:(NSString *)groupID clientActionTime:(UInt32)timeIntervalSince1970 {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
}

- (void)didRemoveGroup:(NSString *)groupID clientActionTime:(UInt32)timeIntervalSince1970 {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
}

- (void)didReceiveText:(NSString *)text fromGroup:(NSString *)groupID fromUser:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    [self receiveNewGroupMessage:groupID];
}

- (void)didReceiveAudioData:(NSData *)data fromGroup:(NSString *)groupID fromUser:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    [self receiveNewGroupMessage:groupID];
}

- (void)didReceivePhoto:(UIImage *)photo fromGroup:(NSString *)groupID fromUser:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    [self receiveNewGroupMessage:groupID];
}


#pragma mark - IMMyself relationship delegate

- (void)relationshipDidInitialize {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMRelationshipDidInitializeNotification object:nil];
}

- (void)didReceiveAgreeToFriendRequestFromUser:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadFriendlistNotification object:nil];
}

- (void)didReceiveFriendRequest:(NSString *)text fromCustomUserID:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    IMExtraAlertView *alertView = [[IMExtraAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ 请求加为好友", customUserID] message:text delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"同意", @"拒绝", nil];
    
    [alertView setExtraData:customUserID];
    [alertView setDelegate:self];
    [alertView show];
}

- (void)didBuildFriendRelationshipWithUser:(NSString *)customUserID {
    _notifyText = @"添加好友成功";
    _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
    [self displayNotifyHUD];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadFriendlistNotification object:nil];
}

- (void)didReceiveRejectFromCustomUserID:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 reason:(NSString *)reason {
    _notifyText = [NSString stringWithFormat:@"%@拒绝了你的好友请求:%@",customUserID,reason];
    _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
    [self displayNotifyHUD];
}

- (void)didBreakUpFriendshipWithCustomUserID:(NSString *)customUserID {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadFriendlistNotification object:nil];
}


#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (![alertView isKindOfClass:[IMExtraAlertView class]]) {
        return;
    }
    
    IMExtraAlertView *extraAlertView = (IMExtraAlertView *)alertView;
    NSString *customUserID = (NSString *)[extraAlertView extraData];
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            [g_pIMMyself agreeToFriendRequestFromUser:customUserID success:^{
                
            } failure:^(NSString *error) {
                _notifyText = @"添加好友失败";
                _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
                [self displayNotifyHUD];
            }];
        }
            break;
        case 2:
        {
            [g_pIMMyself rejectToFriendRequestFromUser:customUserID reason:@"" success:^{
                
            } failure:^(NSString *error) {
                _notifyText = @"拒绝失败";
                _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
                [self displayNotifyHUD];
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark - notify hud

- (BDKNotifyHUD *)notify {
    if (_notify != nil){
        return _notify;
    }
    
    _notify = [BDKNotifyHUD notifyHUDWithImage:_notifyImage text:_notifyText];
    [_notify setCenter:CGPointMake(_tabBarController.view.center.x, _tabBarController.view.center.y - 20)];
    return _notify;
}

- (void)displayNotifyHUD {
    if (_notify) {
        [_notify removeFromSuperview];
        _notify = nil;
    }
    
    [_tabBarController.view addSubview:[self notify]];
    [[self notify] presentWithDuration:1.0f speed:0.5f inView:_tabBarController.view completion:^{
    [[self notify] removeFromSuperview];
    }];
}

/** 设置VC */
- (void)setupViewControllers {
    JYHomeController *homeVC = [[JYHomeController alloc]init];
    UINavigationController *homeNavc = [[UINavigationController alloc]
                                        initWithRootViewController:homeVC];
    
    JYCircleViewController *needsVC = [[JYCircleViewController alloc] init];
    UINavigationController *needsNavc = [[UINavigationController alloc]
                                        initWithRootViewController:needsVC];
    
    JYMessageController *messageVC = [[JYMessageController alloc] init];
    UINavigationController *messageNavc = [[UINavigationController alloc]
                                           initWithRootViewController:messageVC];
    
    JYMineController *profileVC = [[JYMineController alloc] init];
    UINavigationController *profileNavc = [[UINavigationController alloc]
                                           initWithRootViewController:profileVC];
    
    
    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    
    [self customizeTabBarForController:tabBarController];
    
    [tabBarController setViewControllers:@[
                                           homeNavc,
                                           needsNavc,
                                           messageNavc,
                                           profileNavc
                                           ]];
    tabBarController.tabBar.selectedImageTintColor = JYGlobalBg;
    self.tabBarController = tabBarController;
}


/** 设置tabBar */
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"bottom_1",
                            CYLTabBarItemSelectedImage : @"bottom_1_h",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"圈子",
                            CYLTabBarItemImage : @"bottom_2",
                            CYLTabBarItemSelectedImage : @"bottom_2_h",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"消息",
                            CYLTabBarItemImage : @"bottom_3",
                            CYLTabBarItemSelectedImage : @"bottom_3_h",
                            };
    
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"bottom_4",
                            CYLTabBarItemSelectedImage : @"bottom_4_h",
                            };
    
    
    NSArray *tabBarItemsAttributes = @[ dict1, dict2 ,dict3,dict4 ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}


@end
