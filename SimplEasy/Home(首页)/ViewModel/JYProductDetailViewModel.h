//
//  JYProductDetailViewModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/18.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseViewModel.h"
#import "JYProductDetailModel.h"
@interface JYProductDetailViewModel : JYBaseViewModel

- (instancetype)initWithID: (NSInteger)ID;

/** 获取数据 */
- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle;

/** 获得商品描述 */
- (NSString *)descForProduct;

/** 当前价格 */
- (NSString *)currentPriceForProduct;

/** 原始价格 */
- (NSString *)originPriceForProduct;

/** 商品发布时间 */
- (NSString *)publishTimeForProduct;

/** 商品图片数组 */
- (NSArray *)picArrForProduct;

/** 卖家名字 */
- (NSString *)nameForSeller;

/** 卖家头像URL */
- (NSURL *)headImageForSeller;

/** 卖家的学校 */
- (NSString *)schoolNameForSeller;

/** 商品的名字 */
- (NSString *)nameForProduct;

/** 商品URL */
- (NSString *)urlStrForProduct;
@end
