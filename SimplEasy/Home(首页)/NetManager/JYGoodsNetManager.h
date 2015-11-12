//
//  JYGoodsNetManager.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/12.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseNetManager.h"

@interface JYGoodsNetManager : JYBaseNetManager
+(id)getGoodsWithParams:(NSDictionary *)params kCompletionHandle;
@end
