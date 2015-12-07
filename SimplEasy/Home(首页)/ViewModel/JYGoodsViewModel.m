//
//  JYGoodsViewModel.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/12.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYGoodsViewModel.h"
#import "JYGoodsNetManager.h"
#import "JYGoodsModel.h"
@implementation JYGoodsViewModel

- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle{
    self.dataTask = [JYGoodsNetManager getGoodsWithParams:self.params completionHandle:^(JYGoodsModel   *model, NSError *error) {
        [self.dataArr addObjectsFromArray:model.data.items];
        completionHandle(error);
    }];
}

- (void)refreshDataCompletionHandle:(CompletionHandle)completionHandle{
    //清空数据
    [self.dataArr removeAllObjects];
    [self getDataFromNetCompleteHandle:completionHandle];
}
- (void)getMoreDataCompletionHandle:(CompletionHandle)completionHandle{
    [self getDataFromNetCompleteHandle:completionHandle];
}

@end
