//
//  JYLoginRegisterModel.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/12/7.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@class UserData;

@interface JYLoginRegisterModel : JYBaseModel

/** 状态 */
@property (nonatomic, copy) NSString *status;
/** 数据 */
@property (nonatomic, strong) UserData *data;
/** 代码 */
@property (nonatomic, copy) NSString *code;
/** 错误代码 */
@property (nonatomic, copy) NSString *error_code;
/** 错误信息 */
@property (nonatomic, copy) NSString *error_msg;

@end

@interface UserData : JYBaseModel
/** 用户ID */
@property (nonatomic, copy) NSString *ID;
/** 用户名字 */
@property (nonatomic, copy) NSString *name;
/** 用户电话号码 */
@property (nonatomic, copy) NSString *tel;

@end

