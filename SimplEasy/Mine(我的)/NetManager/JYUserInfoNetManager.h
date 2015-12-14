//
//  JYUserInfoNetManager.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/20.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseNetManager.h"

@interface JYUserInfoNetManager : JYBaseNetManager

/** （GET）获取用户列表 */
+ (id)getUserListWithPage: (NSInteger)page kCompletionHandle;

/** （GET）根据用户ID 获取用户信息 */
+ (id)getUserInfoWithUserID: (NSInteger)ID kCompletionHandle;

/**
 *  （POST）根据用户ID 更新用户信息
 *
 *  @param ID     用户ID
 *  @param params 修改的信息，必须包含username和password
 *
 *  @return 返回更新信息
 */
+ (id)updateUserInfoWithUserID: (NSInteger)ID params: (NSDictionary *)params kCompletionHandle;

/** （DELETE）根据用户ID 删除用户 */
+ (id)deleteUserWithUserID: (NSInteger)ID kCompletionHandle;

/** （GET）获取用户当前查看的学校 */
+ (id)getCurrentSchoolCompletionHandle:(void(^)(id model, NSError *error))completionHandle;

/** （POST）根据学校代码 更改用户当前查看的学校 EX：param: school=1 */
+ (id)changeCurrentSchoolWithSchoolID: (NSInteger)schoolID kCompletionHandle;


/**
 *  (POST)发布闲置
 *
 *  @param params 商品参数:需要包括（tel/username/password/title/sort/name/detail/price/图片数组pic）
 *
 *  @return 返回发布状态
 */
+ (id)publishIdleWithParams: (NSDictionary *)params kCompletionHandle;
/**
 *  (POST)根据闲置id删除闲置
 *
 *  @param idleID 闲置id
 *
 *  @return 返回删除状态
 */
+ (id)deleteIdleWithIdleID: (NSInteger)idleID kCompletionHandle;

/**
 *  （GET）获取需求
 *
 *  @param pageSize 要获取的页数
 *  @param userID   获取某个用户的需求，如填nil则获取所有需求
 *
 *  @return 返回需求
 */
+ (id)getNeedsWithPage: (NSInteger)page userID: (NSInteger)userID kCompletionHandle;

/**
 *  （POST）发布需求
 *
 *  @param params 需求参数：需要包括（tel/username/password/detail/price）
 *
 *  @return 返回发布状态
 */
+ (id)publishNeedsWithParams: (NSDictionary *)params kCompletionHandle;

/**
 *  (Delete)根据需求ID删除需求
 *
 *  @param needsID 需求的ID
 *
 *  @return 返回删除状态
 */
+ (id)deleteNeedsWithNeedsID: (NSInteger)needsID kCompletionHandle;

/**
 *  意见反馈
 *
 *  @param userID  用户id
 *  @param opinion 意见内容
 *
 *  @return 反馈结果
 */
+ (id)sendOpinionWithUserID: (NSInteger)userID opinionContent: (NSString *)opinion kCompletionHandle;
@end
