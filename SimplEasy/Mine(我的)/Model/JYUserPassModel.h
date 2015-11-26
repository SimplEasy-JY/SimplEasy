//
//  JYUserPassModel.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/26.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYUserPassModel : NSObject
@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *password;
@property(nonatomic,getter=isLogin)BOOL isLogin;

+(JYUserPassModel *)shareInstance;
@end
