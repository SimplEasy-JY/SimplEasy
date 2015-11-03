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

@interface AppDelegate ()
@property(strong,nonatomic)CYLTabBarController *tabBarController;

@end

@implementation AppDelegate
- (void)setupViewControllers {
    JYHomeController *homeVc = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"JYHomeController"];
    UINavigationController *homeNavc = [[UINavigationController alloc]
                                        initWithRootViewController:homeVc];
    
    JYFindController *shopVC = [[JYFindController alloc] init];
    UINavigationController *shopNavc = [[UINavigationController alloc]
                                        initWithRootViewController:shopVC];
    
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
                                           shopNavc,
                                           messageNavc,
                                           profileNavc
                                           ]];
    self.tabBarController = tabBarController;
}
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"bottom_1",
                            CYLTabBarItemSelectedImage : @"bottom_1_h",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"发现",
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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupViewControllers];
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.设置根控制器
//    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    //    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    //    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    //    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
    self.window.rootViewController = self.tabBarController;
    //    } else { // 这次打开的版本和上一次不一样，显示新特性
    //        self.window.rootViewController = [[JYNewfeatureViewController alloc] init];
    //
    //        // 将当前的版本号存进沙盒
    //        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //    }
    //
    

    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    // 3.显示窗口
    [self.window makeKeyAndVisible];
//    [self initializeWithApplication:application];
    return YES;
}


@end
