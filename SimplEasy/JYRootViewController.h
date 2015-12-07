//
//  IMRootViewController.h
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBaseViewController.h"

@interface JYRootViewController : UIViewController
@property (nonatomic,strong) RESideMenu *sideMenu;
//记录登陆状态
@property(nonatomic,getter=isLogin)BOOL isLogin;
+ (JYRootViewController *)shareRootVC;
@end
