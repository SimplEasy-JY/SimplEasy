//
//  JYLoopViewModel.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYLoopViewModel.h"
#import "JYLoopNetManager.h"
#import "JYLoopModel.h"

@implementation JYLoopViewModel
-(NSMutableArray *)loopImageUrlArray{
    if (!_loopImageUrlArray) {
        _loopImageUrlArray = [NSMutableArray new];
    }
    return _loopImageUrlArray;
}
-(NSMutableArray *)loopWebUrlArray{
    if (!_loopWebUrlArray) {
        self.loopWebUrlArray = [[NSMutableArray  alloc]init];
    }
    return _loopWebUrlArray;
    
}

- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle{
    [self.dataTask cancel];
    self.dataTask = [JYLoopNetManager getLoopImageWithType:self.type completionHandle:^(JYLoopModel *model, NSError *error) {
        if (!error) {
            [self.dataArr addObjectsFromArray:model.data];
            for (int i=0; i<self.dataArr.count; i++) {
                JYLoopImage *loopImage = [JYLoopImage objectWithKeyValues:self.dataArr[i]];
                NSString *imageURL = [NSString stringWithFormat:@"http://www.i-jianyi.com%@",loopImage.src];
                [self.loopImageUrlArray addObject:imageURL];
                [self.loopWebUrlArray addObject:loopImage.link];
            }
        }
        completionHandle(error);
    }];

}

- (void)refreshDataCompletionHandle:(CompletionHandle)completionHandle{
     //清空数据
    [self.dataArr removeAllObjects];
    [self.loopImageUrlArray removeAllObjects];
    [self.loopWebUrlArray removeAllObjects];
    
    
    [self getDataFromNetCompleteHandle:completionHandle];
}
- (void)getMoreDataCompletionHandle:(CompletionHandle)completionHandle{
    [self getDataFromNetCompleteHandle:completionHandle];
}

@end
