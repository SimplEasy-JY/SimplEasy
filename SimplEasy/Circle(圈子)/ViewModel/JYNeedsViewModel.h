//
//  JYCircleViewModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseViewModel.h"

@interface JYNeedsViewModel : JYBaseViewModel

- (instancetype)initWithUserID: (NSInteger)userID;
/** 用户ID */
@property (nonatomic, assign) NSInteger userID;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 行数 */
@property (nonatomic, assign) NSInteger rowNum;
/** 是否是最后一页 */
@property (nonatomic, getter=isLastPage) BOOL lastPage;
/** 需求详情 */
- (NSString *)detailForRow: (NSInteger)row;
/** 发布需求的时间 */
- (NSString *)timeForRow: (NSInteger)row;
/** 需求的ID */
- (NSString *)needsIDForRow: (NSInteger)row;
/** 期望价格 */
- (NSString *)priceForRow: (NSInteger)row;
/** 学校名称 */
- (NSString *)schoolNameForRow: (NSInteger)row;
/** 用户名 */
- (NSString *)userNameForRow: (NSInteger)row;
/** 头像URL */
- (NSURL *)headImgForRow: (NSInteger)row;
/** 电话号码 */
- (NSString *)telForRow: (NSInteger)row;
/** 是否是急需 */
- (BOOL)isUrgentForRow: (NSInteger)row;

@end
