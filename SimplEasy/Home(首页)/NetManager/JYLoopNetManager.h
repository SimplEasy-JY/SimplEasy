//
//  JYLoopNetManager.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseNetManager.h"

@interface JYLoopNetManager : JYBaseNetManager

+(id)getLoopImageWithIndex:(NSInteger)index kCompletionHandle;
@end
