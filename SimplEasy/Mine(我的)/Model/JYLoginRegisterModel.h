//
//  JYLoginRegisterModel.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/12/7.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYLoginRegisterModel : JYBaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *error_code;

@property (nonatomic, copy) NSString *error_msg;


@end
