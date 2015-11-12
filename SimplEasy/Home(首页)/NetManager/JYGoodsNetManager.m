//
//  JYGoodsNetManager.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/12.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYGoodsNetManager.h"
#import "JYGoodsModel.h"
@implementation JYGoodsNetManager
+(id)getGoodsWithParams:(NSDictionary *)params completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path=@"http://www.i-jianyi.com/port/goods/index";
    
    return [self GET:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYGoodsModel objectWithKeyValues:responseObj], error);
        NSLog(@"%@",responseObj);
        NSLog(@"error%@",error);
    }];
}
@end
