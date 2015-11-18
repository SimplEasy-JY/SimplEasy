//
//  JYBaseModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@implementation JYBaseModel

MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
