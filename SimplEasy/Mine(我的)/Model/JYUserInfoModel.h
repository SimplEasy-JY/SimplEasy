//
//  JYUserInfoModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/20.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@class JYUserInfoDataModel;

@interface JYUserInfoModel : JYBaseModel

/** 状态 */
@property (nonatomic, copy) NSString *status;
/** 数据 */
@property (nonatomic, strong) JYUserInfoDataModel *data;
/** 代码 */
@property (nonatomic, copy) NSString *code;


@end

@interface JYUserInfoDataModel : JYBaseModel
/** 教育id */
@property (nonatomic, copy) NSString *eduId;
/** 状态 */
@property (nonatomic, copy) NSString *status;
/** 省份 */
@property (nonatomic, copy) NSString *province;
/** 语言 */
@property (nonatomic, copy) NSString *language;
/** 开放id */
@property (nonatomic, copy) NSString *openId;
/** 国家 */
@property (nonatomic, copy) NSString *country;
/** 电话号码 */
@property (nonatomic, copy) NSString *tel;
/** 自我介绍 */
@property (nonatomic, copy) NSString *selfIntroduction;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 学校 */
@property (nonatomic, copy) NSString *school;
/** 最后坐标 */
@property (nonatomic, copy) NSString *lastY;
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 真实姓名 */
@property (nonatomic, copy) NSString *realName;
/** 名字昵称 */
@property (nonatomic, copy) NSString *name;
/** 最后IP地址 */
@property (nonatomic, copy) NSString *lastIp;
/** 未知 */
@property (nonatomic, copy) NSString *Gamount;
/** 自我简介 */
@property (nonatomic, copy) NSString *selfWords;
/** 头像 */
@property (nonatomic, copy) NSString *headImg;
/** 用户ID */
@property (nonatomic, copy) NSString *ID;
/** 卡 */
@property (nonatomic, copy) NSString *idCard;
/** 邮箱 */
@property (nonatomic, copy) NSString *email;
/** 最后登录事件 */
@property (nonatomic, copy) NSString *lastLogin;
/** 最后坐标 */
@property (nonatomic, copy) NSString *lastX;
/** 当前学校 */
@property (nonatomic, copy) NSString *currentSchool;
/** 无关紧要 */
@property (nonatomic, copy) NSString *roleId;

@end

