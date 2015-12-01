//
//  JYClassifyModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/10.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYClassifyModel : JYBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *selectedIcon;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, assign) NSNumber *index;
@property (nonatomic, strong) NSArray *subClass;

/** 获取分类模型数组 */
+ (NSArray *)classModels;

@end
