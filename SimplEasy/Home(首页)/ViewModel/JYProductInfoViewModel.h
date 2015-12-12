//
//  JYProductInfoModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/23.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseViewModel.h"
#import "JYGoodsNetManager.h"

@interface JYProductInfoViewModel : JYBaseViewModel

- (instancetype)initWithType: (NSString *)type sort: (NSString *)sort;

/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 商品类型 */
@property (nonatomic, copy) NSString *type;
/** 排序方式（子类别） */
@property (nonatomic, strong) NSString *sort;
/** 行数 */
@property (nonatomic, assign) NSInteger rowNum;
/** 是否是最后一页 */
@property (nonatomic, getter=isLastPage) BOOL lastPage;

#pragma mark *** 用户 ***
/** 用户姓名 */
- (NSString *)userNameForRow: (NSInteger)row;
- (NSURL *)userHeaderImageURLForRow: (NSInteger)row;
- (NSString *)schoolNameForRow: (NSInteger)row;

#pragma mark *** 商品 ***
/** 图片URL */
- (NSURL *)imageURLForRow: (NSInteger)row;
/** 商品描述 */
- (NSString *)productDescForRow: (NSInteger)row;
/** 商品现在的价格 */
- (NSString *)currentPriceForRow: (NSInteger)row;
/** 原始价格 */
//- (NSString *)originPriceForRow: (NSInteger)row;
/** 发布日期 */
- (NSString *)publishTimeForRow: (NSInteger)row;
/** 商品ID */
- (NSString *)productIDForRow: (NSInteger)row;

@end
