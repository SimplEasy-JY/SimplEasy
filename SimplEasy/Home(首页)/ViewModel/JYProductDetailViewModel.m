//
//  JYProductDetailViewModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/18.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductDetailViewModel.h"
#import "JYProductDetailNetManager.h"

@implementation JYProductDetailViewModel


- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle{
    self.dataTask = [JYProductDetailNetManager getProductDetailInfoWithId:_ID completionHandle:^(JYProductDetailModel *model, NSError *error) {
        [self.dataArr addObject:model.data];
        completionHandle(error);
    }];
}

- (JYProductDetailDataModel *)model{
    return self.dataArr.firstObject;
}

- (NSString *)descForProduct{
    return [NSString stringWithFormat:@"[%@] %@",[self model].name,[self model].detail];
}
- (NSString *)currentPriceForProduct{
    return [self model].price;
}

- (NSString *)originPriceForProduct{
    return [self model].oldprice;
}

- (NSString *)publishTimeForProduct{
    return [self model].time;
}

@end
