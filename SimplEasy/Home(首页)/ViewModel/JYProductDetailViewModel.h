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

@property (nonatomic, assign) NSInteger ID;

- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle;

- (NSString *)descForProduct;

- (NSString *)currentPriceForProduct;

- (NSString *)originPriceForProduct;

- (NSString *)publishTimeForProduct;

- (JYProductDetailDataModel *)model;

@end
