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

#import <SMS_SDK/SMSSDK.h>
#import "JYLoginViewController.h"
#import "IMDefine.h"
//#import "JYUserDialogViewController.h"

//IMSDK Headers
#import "IMSDK.h"
#import "IMMyself.h"
@interface AppDelegate ()


@end

@implementation AppDelegate

/** 应用程序入口 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self configGlobalUIStyle];
    
    [g_pIMSDK initWithAppKey:IMDeveloper_APPKey];
    
    /** 网络状态检测 */
    [self initializeWithApplication:application];

    [self configNewFeatureViewController];
    
    [SMSSDK registerApp:AppKey withSecret:AppSecret];
    
    
    
    return YES;
}

/** 配置全局的UI样式 */
- (void)configGlobalUIStyle{
    /** 去除 TabBar 自带的顶部阴影 */
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    /** 设置statusBar的颜色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    /** UINavigationBar的相关设置 */
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];// 文字颜色
    [[UINavigationBar appearance] setTranslucent:NO];// 透明度
//    [[UINavigationBar appearance] setBarTintColor:JYGlobalBg];//  背景颜色
    
}

/** 设置window */
- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
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
        self.window.rootViewController = rootVC;
    }else{ //这次打开的版本和上一次不一样，显示新特性
        UINavigationController *naiVC = [[UINavigationController alloc]initWithRootViewController:[[JYNewFeatureViewController alloc] init]];
        self.window.rootViewController = naiVC;
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];//将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
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
