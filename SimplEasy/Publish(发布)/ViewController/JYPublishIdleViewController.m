//
//  JYPublishIdleViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/30.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPublishIdleViewController.h"
#import "JYPublishIdleView.h"

@interface JYPublishIdleViewController ()<UIScrollViewDelegate>

/** 发布视图 */
@property (nonatomic, strong) JYPublishIdleView *idleView;

@end

@implementation JYPublishIdleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JYLog(@"\n\n******************** 进入 发布闲置 视图 ********************\n\n");
    [self idleView];

    
}



#pragma mark *** Lazy Loading ***

- (JYPublishIdleView *)idleView {
	if(_idleView == nil) {
		_idleView = [[JYPublishIdleView alloc] init];
        [self.view addSubview:_idleView];
        _idleView.frame = [UIScreen mainScreen].bounds;
	}
	return _idleView;
}

@end
