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

- (instancetype)initWithUserID: (NSInteger)userID
{
    self = [super init];
    if (self) {
        self.userID = userID;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    NSAssert(NO, @"%s:必须使用initWithUserID: 初始化",__FUNCTION__);
    return self;
}
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
    self.dataTask = [JYUserInfoNetManager getNeedsWithPage:_page userID:_userID completionHandle:^(JYNeedsModel *model, NSError *error) {
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
    NSString *time = [self modelForRow:row].time;
    NSString *date = [time componentsSeparatedByString:@" "].firstObject;
    NSArray *arr = [date componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@月-%@日",arr[1],arr[2]];
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
