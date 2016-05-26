//
//  JYGoodsNetManager.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/12.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYGoodsNetManager.h"
#import "JYGoodsModel.h"

#define JYSetTitle(dic,title) [dic setValue: title forKey:@"title"]
#define JYSetSort(dic,sort) [dic setValue: sort forKey: @"sort"]
#define JYSetPage(dic,page) [dic setValue:@(page) forKey:@"page"]

@implementation JYGoodsNetManager
+(id)getGoodsWithParams:(NSDictionary *)params completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path=@"http://wx.i-jianyi.com/port/goods/index";
    
    return [self GET:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYGoodsModel objectWithKeyValues:responseObj], error);
        NSLog(@"error%@",error);
    }];
}

+ (id)getGoodsWithPage:(NSInteger)page title:(NSString *)type sort:(NSString *)sort completionHandle:(void (^)(id, NSError *))completionHandle{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /** 
     //    switch (type) {
     //        case goodsTypeAll: {
     //            JYSetTitle(params, @"all");
     //            break;
     //        }
     //        case goodsTypeNew: {
     //            JYSetTitle(params, @"new");
     //            break;
     //        }
     //        case goodsTypeFree: {
     //            JYSetTitle(params, @"free");
     //            break;
     //        }
     //        case goodsTypeHot: {
     //            JYSetTitle(params, @"hot");
     //            break;
     //        }
     //        case goodsTypeClothes: {
     //            JYSetTitle(params, @"鞋服配饰");
     //            break;
     //        }
     //        case goodsTypeCosmetic: {
     //            JYSetTitle(params, @"个人护理");
     //            break;
     //        }
     //        case goodsTypeDailyUse: {
     //            JYSetTitle(params, @"生活用品");
     //            break;
     //        }
     //        case goodsTypeSport: {
     //            JYSetTitle(params, @"运动户外");
     //            break;
     //        }
     //        case goodsTypeTravelPackage: {
     //            JYSetTitle(params, @"旅行箱包");
     //            break;
     //        }
     //        case goodsTypeDigital: {
     //            JYSetTitle(params, @"数码外设");
     //            break;
     //        }
     //        case goodsTypeCDBook: {
     //            JYSetTitle(params, @"图书音像");
     //            break;
     //        }
     //        case goodsTypeCard: {
     //            JYSetTitle(params, @"卡券转让");
     //            break;
     //        }
     //        case goodsTypeFood: {
     //            JYSetTitle(params, @"食品专区");
     //            break;
     //        }
     //        default: {
     //            NSAssert(NO, @"%s:type类型不正确",__FUNCTION__);
     //            break;
     //        }
     //    }
     */
    NSString *path = [JYURL stringByAppendingPathComponent:@"port/goods/index"];
    JYSetSort(params, sort);
    JYSetPage(params, page);
    JYSetTitle(params, type);
    return [self GET:path parameters:[params copy] completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYGoodsModel objectWithKeyValues:responseObj],error);
    }];
    
}
@end
