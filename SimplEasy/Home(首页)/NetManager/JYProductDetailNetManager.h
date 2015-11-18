//
//  JYProductDetailNetManager.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/17.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseNetManager.h"

@interface JYProductDetailNetManager : JYBaseNetManager

+ (id)getProductDetailInfoWithId:(NSInteger)ID kCompletionHandle;

@end
