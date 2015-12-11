//
//  JYNormalModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYNormalModel.h"

@implementation JYNormalModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"errorCode":@"error_code",
             @"errorMsg":@"error_msg"};
}

@end
