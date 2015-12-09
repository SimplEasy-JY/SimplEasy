//
//  JYUserInfoModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/20.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYUserInfoModel.h"

@implementation JYUserInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data":[JYUserInfoDataModel class]};
}

@end


@implementation JYUserInfoDataModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"eduId":@"edu_id",
             @"ID":@"id",
             @"openId":@"openid",
             @"selfIntroduction":@"self_introduction",
             @"lastY":@"last_y",
             @"realName":@"realname",
             @"lastIp":@"lastip",
             @"selfWords":@"self_words",
             @"headImg":@"heading",
             @"idCard":@"idcard",
             @"lastLogin":@"lastlogin",
             @"lastX":@"last_x",
             @"currentSchool":@"current_school",
             @"roleId":@"role_id"};
}

@end


