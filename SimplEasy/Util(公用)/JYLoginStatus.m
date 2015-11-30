//
//  JYLoginStatus.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/30.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYLoginStatus.h"
static JYLoginStatus *login = nil;
@implementation JYLoginStatus
+(JYLoginStatus *)loginStatus{
    @synchronized(self) {
        if (login == nil) {
            login = [[JYLoginStatus alloc]init];
            login.isLogin = NO;
        }
    }
    return login;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
        if (login == nil) {
            login = [super allocWithZone:zone];
            login.isLogin = NO;
            return login;
        }
    return nil;
}

@end
