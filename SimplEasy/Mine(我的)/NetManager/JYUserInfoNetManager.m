//
//  JYUserInfoNetManager.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/20.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYUserInfoNetManager.h"
#import "JYUserInfoModel.h"
@implementation JYUserInfoNetManager

+ (id)getUserInfoWithUserID:(NSInteger)uid completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path = [JYURL stringByAppendingPathComponent:[NSString stringWithFormat:@"port/user/show/%lu",uid]];
    JYLog(@"用户信息url——%@",path);
    return [self GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYUserInfoModel objectWithKeyValues:responseObj],error);
    }];
    
}
@end
