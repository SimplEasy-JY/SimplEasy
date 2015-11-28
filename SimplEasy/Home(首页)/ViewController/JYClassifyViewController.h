//
//  JYClassifyViewController.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//  侧拉框视图

#import <UIKit/UIKit.h>
#import "JYClassifyContentVC.h"
#import "JYClassifyModel.h"

typedef void(^ReturnBlock)(JYClassifyContentVC *viewController,JYClassifyModel *model);

@interface JYClassifyViewController : UIViewController

- (void)didSelectTypeWithBlock: (ReturnBlock)block;

@end
