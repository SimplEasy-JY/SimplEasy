//
//  JYGoodsModel.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/12.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@class JYGoodsData,JYGoodsItems;
@interface JYGoodsModel : JYBaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) JYGoodsData *data;

@property (nonatomic, copy) NSString *code;

@end
@interface JYGoodsData : JYBaseModel

@property (nonatomic, copy) NSString *before;

@property (nonatomic, copy) NSString *total_pages;

@property (nonatomic, copy) NSString *current;

@property (nonatomic, copy) NSString *next;

@property (nonatomic, copy) NSString *total_items;

@property (nonatomic, copy) NSString *last;

@property (nonatomic, copy) NSString *limit;

@property (nonatomic, copy) NSString *first;

@property (nonatomic, strong) NSArray<JYGoodsItems *> *items;

@end

@interface JYGoodsItems : JYBaseModel

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *schoolname;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@end

