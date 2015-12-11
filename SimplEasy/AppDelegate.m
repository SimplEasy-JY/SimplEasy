//
//  AppDelegate.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "JYCircleViewController.h"
#import "JYHomeController.h"
#import "JYMessageController.h"
#import "JYMineController.h"
#import "JYClassifyViewController.h"
#import "JYNewFeatureViewController.h"
#import "JYRootViewController.h"
#import "JYLoginViewController.h"
#import "JYBaseNetManager.h"

#import "UMSocial.h"//友盟分享
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"

#import <MobClick.h>
#import <SMS_SDK/SMSSDK.h>
#import "JYLoginViewController.h"
#import "IMDefine.h"
//#import "JYUserDialogViewController.h"
//IMSDK Headers
#import "IMSDK.h"
#import "IMMyself.h"

//测试用》》》》》》》》》》》》》》》》》》》》》》》》》
#import "JYUserInfoNetManager.h"
#import "JYLoginManager.h"

#define JYSetTel(string,dic)            [dic setObject:string forKey:@"tel"]
#define JYSetName(string,dic)           [dic setObject:string forKey:@"name"]
#define JYSetPassword(string,dic)       [dic setObject:string forKey:@"password"]
#define JYSetTitle(string, dic)         [dic setObject:string forKey:@"title"]
#define JYSetSort(string, dic)          [dic setObject:string forKey:@"sort"]
#define JYSetDetail(string, dic)        [dic setObject:string forKey:@"detail"]
#define JYSetPrice(string, dic)         [dic setObject:string forKey:@"price"]
#define JYSetPic(string, dic)           [dic setObject:string forKey:@"pic"]
//《《《《《《《《《《《《《《《《《《《《《《《《《《《《《

@interface AppDelegate ()


@end

@implementation AppDelegate

/** 应用程序入口 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self test];
    [self configGlobalUIStyle];
    
    /** 注册友盟分享 */
    [UMSocialData setAppKey:UmengAppKey];
    
    /** 注册IMSDK */
    [g_pIMSDK initWithAppKey:IMDeveloper_APPKey];

    /** 注册友盟分析 */
    [MobClick startWithAppkey:UmengAppKey reportPolicy:BATCH channelId:nil];
    [UMSocialWechatHandler setWXAppId:WXAppKey appSecret:WXAppSecret url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WBAppKey RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    /** 注册短信验证SDK */
    [SMSSDK registerApp:SMSAppKey withSecret:SMSAppSecret];
    
    /** 网络状态检测 */
    [self initializeWithApplication:application];

    [self configNewFeatureViewController];
    return YES;
}

- (void)test{
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//
//    NSString *path = @"http://www.i-jianyi.com/port/resource/imgUpload";
//
//    [[JYUserInfoNetManager sharedAFManager] POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSString *file = [[NSBundle mainBundle] pathForResource:@"LOGO.png" ofType:nil];
//        NSData *data = [NSData dataWithContentsOfFile:file];
//        [formData appendPartWithFileData:data name:@"file" fileName:@"LOGO.png" mimeType:@"png"];
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        JYLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        JYLog(@"%@",error.description);
//    }];
//    [params setObject:@"evenlam@icloud.com" forKey:@"email"];
//    [JYUserInfoNetManager updateUserInfoWithUserID:@"754" params:params completionHandle:^(id model, NSError *error) {
//        NSLog(@"\n\n******************** %@ ********************\n\n",model);
//    }];
    
//    JYSetTel(@"18768102901", params);
//    JYSetPassword(@"123456", params);
//    JYSetName(@"EvenLam", params);
//    [JYLoginManager loginOrRegisterWith:params Login:YES completionHandle:^(id model, NSError *error) {
//        NSLog(@"\n\n******************** %@ ********************\n\n",model);
//    }];
//
//    [JYUserInfoNetManager getUserListWithPage:@"1" completionHandle:^(id model, NSError *error) {
//    }];
//    
//    [JYUserInfoNetManager getCurrentSchoolCompletionHandle:^(id model, NSError *error) {
//        NSLog(@"\n\n******************** %@ ********************\n\n",model);
//    }];
    
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

/** 友盟系统回调 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
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
        if ([g_pIMMyself loginStatus] == IMMyselfLoginStatusNone) {
            [rootVC addChildViewController:loginVC];
            [rootVC.view addSubview:loginVC.view];
        }
            self.window.rootViewController = rootVC;
    }else{ //这次打开的版本和上一次不一样，显示新特性
        JYNewFeatureViewController *newfeatureVC = [[JYNewFeatureViewController alloc] init];
        self.window.rootViewController = newfeatureVC;
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
