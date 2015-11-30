//
//  JYLoginStatus.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/30.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//登录状态的类

#import <Foundation/Foundation.h>

@interface JYLoginStatus : NSObject
@property(nonatomic,getter=isLogin)BOOL isLogin;
+(JYLoginStatus *)loginStatus;
@end
