//
//  JYProductDetailNetManager.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/17.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductDetailNetManager.h"
#import "JYProductDetailModel.h"

@implementation JYProductDetailNetManager

+ (id)getProductDetailInfoWithId:(NSInteger)ID completionHandle:(void (^)(id, NSError *))completionHandle{
    
    NSString *path = [JYURL stringByAppendingPathComponent:[NSString stringWithFormat:@"port/Goods/show/%lu",ID]];
    JYLog(@"详情请求地址为————%@",path);
    return [self GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYProductDetailModel objectWithKeyValues:responseObj],error);
    }];
}

@end
