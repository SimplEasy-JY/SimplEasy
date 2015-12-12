//
//  JYProductInfoModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/23.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductInfoViewModel.h"
#import "JYGoodsModel.h"

@implementation JYProductInfoViewModel

- (instancetype)initWithType:(NSString *)type sort:(NSString *)sort
{
    self = [super init];
    if (self) {
        self.type = type;
        self.sort = sort;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    NSAssert(NO, @"%s:必须使用initWithType: sort: 初始化",__FUNCTION__);
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
    self.dataTask = [JYGoodsNetManager getGoodsWithPage:_page title:_type sort:_sort completionHandle:^(JYGoodsModel *model, NSError *error) {
        if (!error) {
            _lastPage = [model.data.last isEqualToString:model.data.current];
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

- (JYGoodsItems *)modelForRow: (NSInteger)row{
     return self.dataArr[row];
}

#pragma mark *** 用户 ***
/** 用户姓名 */
- (NSString *)userNameForRow: (NSInteger)row{
    return [self modelForRow:row].username;
}
- (NSURL *)userHeaderImageURLForRow: (NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].headImg];
}
- (NSString *)schoolNameForRow: (NSInteger)row{
    return [self modelForRow:row].schoolname;
}

#pragma mark *** 商品 ***
/** 图片URL */
- (NSURL *)imageURLForRow: (NSInteger)row{
    return [self modelForRow:row].pic?[NSURL URLWithString:[JYURL stringByAppendingString:[self modelForRow:row].pic]]:nil;
}
/** 商品描述 */
- (NSString *)productDescForRow: (NSInteger)row{
    return [self modelForRow:row].name;
}

/** 商品现在的价格 */
- (NSString *)currentPriceForRow: (NSInteger)row{
    return [self modelForRow:row].price;
}
///** 原始价格 */
//- (NSString *)originPriceForRow: (NSInteger)row{
//
//}
/** 发布日期 */
- (NSString *)publishTimeForRow: (NSInteger)row{
    NSString *time = [self modelForRow:row].time;
    NSString *day = [time componentsSeparatedByString:@" "].firstObject;
    NSArray *date = [day componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@-%@",date[1],date[2]];
}

/** 商品ID */
- (NSString *)productIDForRow: (NSInteger)row{
    return [self modelForRow:row].ID;
}

@end
