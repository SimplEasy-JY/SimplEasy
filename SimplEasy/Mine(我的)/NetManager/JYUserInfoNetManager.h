//
//  JYUserInfoNetManager.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/20.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseNetManager.h"

@interface JYUserInfoNetManager : JYBaseNetManager

+ (id)getUserInfoWithUserID: (NSInteger)ID kCompletionHandle;

@end
