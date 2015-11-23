//
//  JYGoodsNetManager.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/12.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseNetManager.h"

typedef NS_ENUM(NSUInteger, goodsType) {
/** 主页类别 */
    goodsTypeAll,           //获取全部
    goodsTypeNew,           //获取今日上新
    goodsTypeFree,          //获取免费商品
    goodsTypeHot,           //获取热门商品
/** 侧拉框类别 */
    goodsTypeClothes,       //获取鞋服配饰
    goodsTypeCosmetic,      //获取个人护理
    goodsTypeDailyUse,      //获取生活用品
    goodsTypeSport,         //获取运动户外
    goodsTypeTravelPackage, //获取旅行箱包
    goodsTypeDigital,       //获取数码外设
    goodsTypeCDBook,        //获取图书音像
    goodsTypeCard,          //获取卡券转让
    goodsTypeFood           //获取食品专区
};

@interface JYGoodsNetManager : JYBaseNetManager

+(id)getGoodsWithParams:(NSDictionary *)params kCompletionHandle;

/**
 *  获取某种类型的所有商品
 *
 *  @param page 页数
 *  @param type 商品类型
 *  @param sort 排序方式（子类型）
 *
 *  @return 请求所在任务
 */
+ (id)getGoodsWithPage: (NSInteger)page title: (NSString *)type sort: (NSString *)sort kCompletionHandle;

@end
