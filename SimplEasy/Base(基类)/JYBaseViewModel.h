//
//  JYBaseViewModel.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionHandle)(NSError *error);

@protocol JYBaseViewModelDelegate <NSObject>

@optional

/** 获取更多数据 */
- (void)getMoreDataCompletionHandle:(CompletionHandle)completionHandle;

/** 刷新数据 */
- (void)refreshDataCompletionHandle:(CompletionHandle)completionHandle;

/** 获取数据 */
- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle;

@end

@interface JYBaseViewModel : NSObject <JYBaseViewModelDelegate>

@property(nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) NSURLSessionDataTask *dataTask;

/** 取消任务 */
- (void)cancelTask;

/** 暂停任务 */
- (void)suspendTask;

/** 继续任务 */
- (void)resumeTask;

@end
