//
//  JYBaseNetManager.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYBaseNetManager : NSObject

+ (id)GET:(NSString *)path parameters:(NSDictionary *)params completionHandle:(void(^)(id responseObj, NSError *error))complete;

+ (id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandle:(void(^)(id responseObj, NSError *error))complete;

@end
