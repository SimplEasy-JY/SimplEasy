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

- (NSArray *)picArrForProduct{
    NSMutableArray *arr = [NSMutableArray new];
#warning 这里现在只有一张图片，等后台改成数组再改
    JYLog(@"图片:------%@",[self model].pic);
    NSString *imageStr = [JYURL stringByAppendingString:[self model].pic];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    [arr addObject:imageUrl];
    return [arr copy];
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
