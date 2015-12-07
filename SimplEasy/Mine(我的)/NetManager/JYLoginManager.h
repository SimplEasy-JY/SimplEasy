//
//  JYLoginManager.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/12/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseNetManager.h"

@interface JYLoginManager : JYBaseNetManager
+(id)loginOrRegisterWith:(NSDictionary *)parms Login:(BOOL)isLogin kCompletionHandle;
@end
