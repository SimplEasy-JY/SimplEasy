//
//  JYCircleViewModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYNeedsViewModel.h"
#import "JYUserInfoNetManager.h"
#import "JYNeedsModel.h"

@implementation JYNeedsViewModel


- (void)refreshDataCompletionHandle:(CompletionHandle)completionHandle{
    _page = 1;
    [self getDataFromNetCompleteHandle:completionHandle];
}

- (void)getMoreDataCompletionHandle:(CompletionHandle)completionHandle{
    _page += 1;
    [self getDataFromNetCompleteHandle:completionHandle];
}

- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle{
    [self.dataTask cancel];
    self.dataTask = [JYUserInfoNetManager getNeedsWithPage:_page userID:nil completionHandle:^(JYNeedsModel *model, NSError *error) {
        if (!error) {
            _lastPage = [model.data.current isEqualToString:model.data.last];
            if (_page == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:model.data.items];
        }
        completionHandle(error);
    }];
}

- (NSInteger)rowNum{
    return self.dataArr.count;
}

- (JYNeedsDataItemsModel *)modelForRow: (NSInteger)row{
    return self.dataArr[row];
}

- (NSString *)detailForRow: (NSInteger)row{
    return [self modelForRow:row].detail;
}

- (NSString *)timeForRow: (NSInteger)row{
    return [self modelForRow:row].time;
}

- (NSString *)needsIDForRow: (NSInteger)row{
    return [self modelForRow:row].ID;
}

- (NSString *)priceForRow: (NSInteger)row{
    return [self modelForRow:row].price;
}

- (NSString *)schoolNameForRow: (NSInteger)row{
    return [self modelForRow:row].schoolName;
}

- (NSString *)userNameForRow: (NSInteger)row{
    return [self modelForRow:row].userName;
}

- (NSURL *)headImgForRow: (NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].headImg];
}

- (NSString *)telForRow: (NSInteger)row{
    return [self modelForRow:row].tel;
}

@end
