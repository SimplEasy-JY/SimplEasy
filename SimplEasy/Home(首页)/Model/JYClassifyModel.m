//
//  JYClassifyModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/10.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassifyModel.h"

@implementation JYClassifyModel

+ (NSArray *)classModels{
    NSArray *classArr = [NSArray objectArrayWithFilename:@"Classify.plist"];
    NSMutableArray *mutableArr = [NSMutableArray new];
    for (NSDictionary *dict in classArr) {
        JYClassifyModel *model = [JYClassifyModel new];
        [model setValuesForKeysWithDictionary:dict];
        [mutableArr addObject:model];
    }
    classArr = [mutableArr copy];
    return classArr;
}

@end
