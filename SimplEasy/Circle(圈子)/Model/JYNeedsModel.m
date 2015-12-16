//
//  JYNeedsModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYNeedsModel.h"

@implementation JYNeedsModel

@end

@implementation JYNeedsDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"totalPages": @"total_pages",
             @"totalItems": @"total_items"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"items" : [JYNeedsDataItemsModel class]};
}

@end


@implementation JYNeedsDataItemsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID": @"id",
             @"schoolName": @"schoolname",
             @"userName": @"username",
             @"headImg": @"headimg"};
}

@end


