//
//  JYUserInfoNetManager.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/20.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYUserInfoNetManager.h"
#import "JYUserInfoModel.h"
#import "JYNormalModel.h"
#import "JYNeedsModel.h"

//路径设置
#define JYUserPort @"http://www.i-jianyi.com/port/user"
#define JYSetUserPort(string)       [JYUserPort stringByAppendingPathComponent:string]
#define JYSetID(string,ID)          [string stringByAppendingPathComponent:ID]
//参数设置
#define JYSetPage(string,dic)           [dic setObject:string forKey:@"page"]
#define JYSetNum(string,dic)            [dic setObject:string forKey:@"num"]
#define JYSetSchool(string,dic)         [dic setObject:string forKey:@"school"]

@implementation JYUserInfoNetManager

#pragma mark *** 用户相关操作 ***

+ (id)getUserListWithPage:(NSString *)page completionHandle:(void (^)(id, NSError *))completionHandle {
    
    NSString *path = JYSetUserPort(@"index");
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    JYSetPage(@"1", params);
    JYSetNum(@"10", params);
    
    return [self GET:path parameters:params completionHandle:^(id responseObj, NSError *error) {
#warning TODO
        completionHandle(responseObj,error);
    }];
}

+ (id)getUserInfoWithUserID:(NSString *)ID completionHandle:(void (^)(id, NSError *))completionHandle {

    NSString *path = JYSetUserPort(@"show");

    path = JYSetID(path, ID);
    JYLog(@"用户信息URL————%@",path);
    
    return [self GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYUserInfoModel objectWithKeyValues:responseObj],error);
    }];
    
}

+ (id)updateUserInfoWithUserID:(NSString *)ID params:(NSDictionary *)params completionHandle:(void (^)(id, NSError *))completionHandle {
  
    //如果更新信息参数没有username和password，让程序崩溃
    NSAssert([params.allKeys containsObject:@"username"]&&[params.allKeys containsObject:@"password"], @"必须包含tel和password！");
    
    NSString *path = JYSetUserPort(@"update");
    path = JYSetID(path, ID);

    return [self POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYNormalModel mj_objectWithKeyValues:responseObj] ,error);
    }];
}

+ (id)deleteUserWithUserID:(NSString *)ID completionHandle:(void (^)(id, NSError *))completionHandle {
 
    NSString *path = JYSetUserPort(@"destory");
    path = JYSetID(path, ID);
  
    return [self DELETE:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYNormalModel mj_objectWithKeyValues:responseObj],error);
    }];
    
}

+ (id)getCurrentSchoolCompletionHandle:(void (^)(id, NSError *))completionHandle {
   
    NSString *path = JYSetUserPort(@"currentSchool");
    
    return [self GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
#warning TODO
        completionHandle(responseObj,error);
    }];
}

+ (id)changeCurrentSchoolWithSchoolID:(NSString *)schoolID completionHandle:(void (^)(id, NSError *))completionHandle {
  
    NSString *path = JYSetUserPort(@"changeCurrentSchool");
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    JYSetSchool(schoolID, params);
    
    return [self POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYNormalModel mj_objectWithKeyValues:responseObj],error);
    }];
}


#pragma mark *** 发布闲置和需求 ***

+ (id)publishIdleWithParams:(NSDictionary *)params completionHandle:(void (^)(id, NSError *))completionHandle {
    //没有包括必须发布的信息则程序崩溃
    NSAssert([params.allKeys containsObject:@"tel"]&&[params.allKeys containsObject:@"username"]&&[params.allKeys containsObject:@"password"]&&[params.allKeys containsObject:@"title"]&&[params.allKeys containsObject:@"sort"]&&[params.allKeys containsObject:@"name"]&&[params.allKeys containsObject:@"detail"]&&[params.allKeys containsObject:@"price"]&&[params.allKeys containsObject:@"pic"], @"发布的信息必须包括tel/password/title/sort/name/detail/price/图片数组pic");
    
    NSString *path = @"http://www.i-jianyi.com/port/goods/create";
    
    return [self POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYNormalModel mj_objectWithKeyValues:responseObj],error);
    }];
}

+ (id)getNeedsWithPageSize:(NSString *)pageSize userID:(NSString *)userID completionHandle:(void (^)(id, NSError *))completionHandle {

    NSString *path = @"http://www.i-jianyi.com/port/needs/index";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:pageSize forKey:@"page_size"];
    [params setObject:userID forKey:@"user_id"];
    
    return [self GET:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYNeedsModel mj_objectWithKeyValues:responseObj],error);
    }];
}

+ (id)publishNeedsWithParams:(NSDictionary *)params completionHandle:(void (^)(id, NSError *))completionHandle {
   
    NSAssert([params.allKeys containsObject:@"tel"]&&[params.allKeys containsObject:@"username"]&&[params.allKeys containsObject:@"password"]&&[params.allKeys containsObject:@"detail"]&&[params.allKeys containsObject:@"price"], @"发布需求的信息必须包括tel／password／detail／price!!!");
    
    NSString *path = @"http://www.i-jianyi.com/port/needs/create";
    
    return [self POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        completionHandle([JYNormalModel mj_objectWithKeyValues:responseObj],error);
    }];
}

@end
