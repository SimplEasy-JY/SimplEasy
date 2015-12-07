//
//  JYLoginManager.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/12/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYLoginManager.h"
#import "JYLoginRegisterModel.h"
@implementation JYLoginManager
+(id)loginOrRegisterWith:(NSDictionary *)parms Login:(BOOL)isLogin completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path = nil;
    if (isLogin) {
        path = @"http://www.i-jianyi.com/port/sign/index";
    }else {
        path = @"http://www.i-jianyi.com/port/sign/register";
    }
    return [self POST:path parameters:parms completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYLoginRegisterModel objectWithKeyValues:responseObj], error);
    }];
}
@end
