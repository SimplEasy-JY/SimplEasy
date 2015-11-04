//
//  JYLoopNetManager.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYLoopNetManager.h"

@implementation JYLoopNetManager
+(id)getLoopImageWithIndex:(NSInteger)index completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path=@"http://www.i-jianyi.com/port/img/index";
//    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
//        completionHandle([JYLoopModel objectWithKeyValues:responseObj], error);
//    }];
   
   return [self GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYLoopModel objectWithKeyValues:responseObj], error);
 
    }];
    
}
@end
