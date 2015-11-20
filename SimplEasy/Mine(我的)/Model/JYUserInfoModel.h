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


@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) JYUserInfoDataModel *data;

@property (nonatomic, copy) NSString *code;


@end

@interface JYUserInfoDataModel : NSObject

@property (nonatomic, copy) NSString *eduId;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *openId;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *selfIntroduction;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *school;

@property (nonatomic, copy) NSString *lastY;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *lastIp;

@property (nonatomic, copy) NSString *Gamount;

@property (nonatomic, copy) NSString *selfWords;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idCard;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *lastLogin;

@property (nonatomic, copy) NSString *lastX;

@property (nonatomic, copy) NSString *currentSchool;

@property (nonatomic, copy) NSString *roleId;

@end

