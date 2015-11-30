//
//  JYFileManager.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/30.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JYFileManager : NSObject

+ (instancetype)defaultManager;
/**
 *  获取指定目录文件的大小
 *
 *  @param path 指定的文件目录
 *
 *  @return 返回大小
 */
- (CGFloat)fileSizeAtPath: (NSString *)path;

/**
 *  获取指定目录文件夹的大小
 *
 *  @param path 文件夹目录
 *
 *  @return 文件夹大小
 */
- (CGFloat)folderSizeAtPath: (NSString *)path;

/**
 *  清除指定目录的缓存
 *
 *  @param path 要清除的目录路径
 */
- (void)clearCacheAtPath: (NSString *)path;

@end
