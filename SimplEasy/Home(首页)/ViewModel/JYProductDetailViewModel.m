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
#define PRODUCT_DETAIL @"http://wx.i-jianyi.com/frontend/goods/detail/"//后面接上商品id

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
    [self.dataTask cancel];
    self.dataTask = [JYProductDetailNetManager getProductDetailInfoWithId:_ID completionHandle:^(JYProductDetailModel *model, NSError *error) {
        if (!error) {
            JYProductDetailDataModel *dataModel = model.data;
            [self.dataArr addObject:model.data];
            self.userDataTask = [JYUserInfoNetManager getUserInfoWithUserID:dataModel.uid.integerValue completionHandle:^(JYUserInfoModel *model, NSError *error) {
                if (!error) {
                    self.userDataArr = [NSMutableArray array];
                    [self.userDataArr addObject:model.data];
                }
                completionHandle(error);
            }];
        }
        completionHandle(error);
        
    }];
    
}

- (JYProductDetailDataModel *)model{
    return self.dataArr.firstObject;
}

- (NSString *)urlStrForProduct{
    return [PRODUCT_DETAIL stringByAppendingString:[NSString stringWithFormat:@"%ld",self.ID]];
}
- (NSString *)shareTitle{
    return @"简易一周年！ 送货上门，限时抢购！";
}
- (NSString *)nameForProduct{
    return [self model].name;
}

- (NSString *)descForProduct{
//    return [NSString stringWithFormat:@"[%@]\n%@",[self model].name,[self model].detail];
    return [self model].detail;
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

#warning 暂时弃用这个学校名
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
    NSString *time = [self model].time?[self requiredTime:[self model].time]:nil;
    return time;
}

/**
 *  格式化时间
 *
 *  @param publishTime 传入的时间格式为:2015-02-15 18:09:38
 *
 *  @return 根据距离现在的时间返回不同的字符串
 */
- (NSString *)requiredTime: (NSString *)publishTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设置格式
    
    NSDate *publishDate = [dateFormatter dateFromString:publishTime];// 开始时间
    NSDate *now = [NSDate date];// 结束时间
    
    //设置日历单元 **这个不能漏写**
    NSCalendarUnit unit =NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    //设置日期组件
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:publishDate toDate:now options:0];
    if (cmps.month >= 1) {
        return [NSString stringWithFormat:@"%ld个月前",cmps.month];
    }else if(cmps.day>=3){
        return [NSString stringWithFormat:@"%ld天前",cmps.day];
    }else if (cmps.day<1){
        if (cmps.hour==0) {
            return [NSString stringWithFormat:@"%ld分钟前",cmps.minute];
        }
        return [NSString stringWithFormat:@"%ld小时前",cmps.hour];
    }else{
        return [NSString stringWithFormat:@"%ld天 %ld小时前",cmps.day,cmps.hour];
    }
}

@end
