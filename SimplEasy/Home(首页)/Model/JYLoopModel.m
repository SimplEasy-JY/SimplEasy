//
//  JYLoopModel.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYLoopModel.h"

@implementation JYLoopModel


+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [JYLoopImage class]};
}

@end
@implementation JYLoopImage
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID": @"id",
             };
}
@end


