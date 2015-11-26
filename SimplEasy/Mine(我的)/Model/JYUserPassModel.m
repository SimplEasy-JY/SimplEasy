//
//  JYUserPassModel.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/26.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYUserPassModel.h"

@implementation JYUserPassModel

static JYUserPassModel *_instance = nil;

+(JYUserPassModel *)shareInstance
{
    @synchronized(self) {
        if (_instance == nil)
        {
            _instance = [[super alloc]init];
        }
    }
    return _instance;
  }

-(id)init{
    if (self = [super init]){
        self.userName = [[NSString alloc]init];
        self.password = [[NSString alloc]init];
        }
    return self;
}
@end
