//
//  IMSDKManager.h
//  IMDeveloper
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSDKManager : NSObject

@property (nonatomic, readonly)NSMutableArray *recentChatObjects;

+ (instancetype)sharedInstance;

- (void)removeRecentChatObject:(NSString *)object;
#define g_pIMSDKManager [JYSDKManager sharedInstance]
@end
