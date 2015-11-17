//
//  AppDelegate.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 网络状态 */
@property(nonatomic,getter=isOnLine) BOOL onLine;
//@property (nonatomic,strong) RESideMenu *sideMenu;

@end

