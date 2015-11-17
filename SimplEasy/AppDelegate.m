//
//  AppDelegate.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "JYFindController.h"
#import "JYHomeController.h"
#import "JYMessageController.h"
#import "JYMineController.h"
#import "JYClassifyViewController.h"
#import "JYNewFeatureViewController.h"
#import "JYRootViewController.h"



#import "JYLoginViewController.h"
#import "IMDefine.h"
//#import "JYUserDialogViewController.h"

//IMSDK Headers
#import "IMSDK.h"
#import "IMMyself.h"
@interface AppDelegate ()

//@property(strong,nonatomic)CYLTabBarController *tabBarController;

@end

@implementation AppDelegate

///** 设置VC */
//- (void)setupViewControllers {
//    
//    UINavigationController *homeNavc = [[UINavigationController alloc]
//                                        initWithRootViewController:kVCFromSb(@"JYHomeController", @"Main")];
//    
//    JYFindController *shopVC = [[JYFindController alloc] init];
//    UINavigationController *shopNavc = [[UINavigationController alloc]
//                                        initWithRootViewController:shopVC];
//    
//    JYMessageController *messageVC = [[JYMessageController alloc] init];
//    UINavigationController *messageNavc = [[UINavigationController alloc]
//                                           initWithRootViewController:messageVC];
//    
//    JYMineController *profileVC = [[JYMineController alloc] init];
//    UINavigationController *profileNavc = [[UINavigationController alloc]
//                                           initWithRootViewController:profileVC];
//    
//    
//    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
//    
//    [self customizeTabBarForController:tabBarController];
//    
//    [tabBarController setViewControllers:@[
//                                           homeNavc,
//                                           shopNavc,
//                                           messageNavc,
//                                           profileNavc
//                                           ]];
//    tabBarController.tabBar.selectedImageTintColor = JYGlobalBg;
//    self.tabBarController = tabBarController;
//}
//
///** 设置tabBar */
//- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
//    
//    NSDictionary *dict1 = @{
//                            CYLTabBarItemTitle : @"首页",
//                            CYLTabBarItemImage : @"bottom_1",
//                            CYLTabBarItemSelectedImage : @"bottom_1_h",
//                            };
//    NSDictionary *dict2 = @{
//                            CYLTabBarItemTitle : @"发现",
//                            CYLTabBarItemImage : @"bottom_2",
//                            CYLTabBarItemSelectedImage : @"bottom_2_h",
//                            };
//    NSDictionary *dict3 = @{
//                            CYLTabBarItemTitle : @"消息",
//                            CYLTabBarItemImage : @"bottom_3",
//                            CYLTabBarItemSelectedImage : @"bottom_3_h",
//                            };
//    
//    NSDictionary *dict4 = @{
//                            CYLTabBarItemTitle : @"我的",
//                            CYLTabBarItemImage : @"bottom_4",
//                            CYLTabBarItemSelectedImage : @"bottom_4_h",
//                            };
//    
//    
//    NSArray *tabBarItemsAttributes = @[ dict1, dict2 ,dict3,dict4 ];
//    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
//}
//
///** 设置侧拉框 */
//- (RESideMenu *)sideMenu{
//    if (!_sideMenu) {
//        _sideMenu=[[RESideMenu alloc]initWithContentViewController:self.tabBarController leftMenuViewController:[JYClassifyViewController new] rightMenuViewController:nil];
//        /** 让侧拉框不能通过手势调出，解决每个tabBar都会调出侧拉框的问题 */
//        _sideMenu.panGestureEnabled = NO;
//        /** 可以让出现菜单时不显示状态栏 */
//        _sideMenu.menuPrefersStatusBarHidden = YES;
//        /** 关闭透视，视差效果 */
//        _sideMenu.parallaxEnabled = NO;
//        _sideMenu.contentViewInPortraitOffsetCenterX = 80;
//        _sideMenu.contentViewScaleValue = 1.0f;
//    }
//    return _sideMenu;
//}


/** 设置window */
- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}

/** 配置全局的UI样式 */
- (void)configGlobalUIStyle{
    /** 去除 TabBar 自带的顶部阴影 */
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:JYGlobalBg];
    [[UINavigationBar appearance] setTranslucent:NO];

}

/** 配置新特性（或欢迎界面） */
- (void)configNewFeatureViewController{
    //设置根控制器
    NSString *key = @"CFBundleVersion";
    
    //上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    //版本号相同：这次打开和上次打开的是同一个版本,根控制器就是sideMenu
    if ([currentVersion isEqualToString:lastVersion]) {
        NSLog(@"%@",rootVC);
        self.window.rootViewController = rootVC.sideMenu;
    }else{ //这次打开的版本和上一次不一样，显示新特性
        self.window.rootViewController = [[JYNewFeatureViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];//将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

/** 应用程序入口 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [g_pIMSDK initWithAppKey:IMDeveloper_APPKey];
    
    /** 网络状态检测 */
    [self initializeWithApplication:application];
    /** 以下两行代码先后顺序不可打乱 */
//    [self setupViewControllers];
    [self configNewFeatureViewController];
    [self configGlobalUIStyle];
    
    
    
    return YES;
}
/**  程序进入后台 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [g_pIMSDK applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [g_pIMSDK applicationWillEnterForeground];
}


@end
