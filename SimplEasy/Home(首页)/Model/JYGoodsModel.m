//
//  JYGoodsModel.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/12.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYGoodsModel.h"

@implementation JYGoodsModel
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [JYGoodsData class]};
}
@end



@implementation JYGoodsData

+ (NSDictionary *)objectClassInArray{
    return @{@"items" : [JYGoodsItems class]};
}

@end


@implementation JYGoodsItems


@end


