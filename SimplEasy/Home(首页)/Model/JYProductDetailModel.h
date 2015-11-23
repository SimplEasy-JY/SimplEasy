//
//  JYProductDetailModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/17.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@class JYProductDetailDataModel;

@interface JYProductDetailModel : JYBaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) JYProductDetailDataModel *data;

@property (nonatomic, copy) NSString *code;

@end

@interface JYProductDetailDataModel : JYBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *x;

@property (nonatomic, copy) NSString *oldprice;

@property (nonatomic, copy) NSString *y;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *way;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *del;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *viewcount;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *top;

@property (nonatomic, strong) NSArray *pics;

@end

@interface JYProductDetailDataPicsModel : JYBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *gid;

@property (nonatomic, copy) NSString *del;

@end

