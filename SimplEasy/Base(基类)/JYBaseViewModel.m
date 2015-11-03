//
//  JYBaseViewModel.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYBaseViewModel.h"

@implementation JYBaseViewModel

- (void)cancelTask{
    [self.dataTask cancel];
}

- (void)suspendTask{
    [self.dataTask suspend];
}

- (void)resumeTask{
    [self.dataTask resume];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
