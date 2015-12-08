//
//  JYLoginRegisterModel.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/12/7.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@class userData;
@interface JYLoginRegisterModel : JYBaseModel


@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) userData *data;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *error_code;

@property (nonatomic, copy) NSString *error_msg;

@end
@interface userData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *tel;

@end

