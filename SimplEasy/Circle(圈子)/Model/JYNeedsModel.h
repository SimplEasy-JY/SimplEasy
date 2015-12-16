//
//  JYNeedsModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@class JYNeedsDataModel,JYNeedsDataItemsModel;
@interface JYNeedsModel : JYBaseModel


@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) JYNeedsDataModel *data;

@property (nonatomic, copy) NSString *code;


@end
@interface JYNeedsDataModel : JYBaseModel

@property (nonatomic, copy) NSString *before;

@property (nonatomic, copy) NSString *totalPages;

@property (nonatomic, copy) NSString *current;

@property (nonatomic, copy) NSString *next;

@property (nonatomic, copy) NSString *totalItems;

@property (nonatomic, copy) NSString *last;

@property (nonatomic, copy) NSString *limit;

@property (nonatomic, copy) NSString *first;

@property (nonatomic, strong) NSArray<JYNeedsDataItemsModel *> *items;

@end

@interface JYNeedsDataItemsModel : JYBaseModel

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *schoolName;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *tel;

@end

