//
//  JYLoopNetManager.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYLoopNetManager.h"
#import "JYLoopModel.h"
@implementation JYLoopNetManager
+(id)getLoopImageWithType:(NSInteger)type completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path=[NSString stringWithFormat:@"http://wx.i-jianyi.com/port/img?type=%ld",type];
   
   return [self GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYLoopModel objectWithKeyValues:responseObj], error);
 
    }];
    
}
@end
