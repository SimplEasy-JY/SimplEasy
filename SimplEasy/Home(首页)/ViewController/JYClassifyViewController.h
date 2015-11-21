//
//  JYClassifyViewController.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//  侧拉框视图

#import <UIKit/UIKit.h>

typedef void(^ReturnBlock)(UIViewController *viewController,NSString *selectedType);

@interface JYClassifyViewController : UIViewController

- (void)didSelectTypeWithBlock: (ReturnBlock)block;

@end
