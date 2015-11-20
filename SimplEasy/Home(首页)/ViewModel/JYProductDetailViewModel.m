//
//  JYProductDetailViewModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/18.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductDetailViewModel.h"
#import "JYProductDetailNetManager.h"
#import "JYUserInfoNetManager.h"
#import "JYUserInfoModel.h"


@interface JYProductDetailViewModel ()

@property (nonatomic, strong) NSURLSessionDataTask *userDataTask;
@property (nonatomic, strong) NSMutableArray *userDataArr;
@property (nonatomic, assign) NSInteger ID;
@end

@implementation JYProductDetailViewModel

- (instancetype)initWithID: (NSInteger)ID{
    if (self = [super init]) {
        self.ID = ID;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    NSAssert(NO, @"%s:必须使用initWithID初始化",__FUNCTION__);
    return self;
}

- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle{
    self.dataTask = [JYProductDetailNetManager getProductDetailInfoWithId:_ID completionHandle:^(JYProductDetailModel *model, NSError *error) {
        JYProductDetailDataModel *dataModel = model.data;
        [self.dataArr addObject:model.data];
        
        completionHandle(error);
        
        self.userDataTask = [JYUserInfoNetManager getUserInfoWithUserID:[dataModel.uid integerValue] completionHandle:^(JYUserInfoModel *model, NSError *error) {
            self.userDataArr = [NSMutableArray array];
            [self.userDataArr addObject:model.data];
            completionHandle(error);
        }];
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
    if (![self model].pics) {
        return nil;
    }
    for (JYProductDetailDataPicsModel *picsModel in [self model].pics) {
        NSString *imageStr = [JYURL stringByAppendingString:picsModel.pic];
        NSURL *imageUrl = [NSURL URLWithString:imageStr];
        [arr addObject:imageUrl];
    }
    return [arr copy];
}

- (JYUserInfoDataModel *)userDataModel{
    return self.userDataArr.firstObject;
}

- (NSString *)nameForSeller{
    return [self userDataModel].name;
}

- (NSURL *)headImageForSeller{
    return [NSURL URLWithString:[self userDataModel].headImg];
}

- (NSString *)schoolNameForSeller{
    return [self userDataModel].school;
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
