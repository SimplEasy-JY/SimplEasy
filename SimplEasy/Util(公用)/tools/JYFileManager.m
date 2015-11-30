//
//  JYFileManager.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/30.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYFileManager.h"

static JYFileManager *fm = nil;

@implementation JYFileManager

- (CGFloat)fileSizeAtPath: (NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

- (CGFloat)folderSizeAtPath: (NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

- (void)clearCacheAtPath: (NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!fm) {
            fm = [[JYFileManager alloc] init];
        }
    });
    return fm;
}

//当alloc当前类的对象时自动调用的方法
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (fm == nil) {
        fm = [super allocWithZone:zone];
        return fm;
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

@end
