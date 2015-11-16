//
//  UIButton+VerticalBtn.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/16.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (VerticalBtn)

/**
 *  设置按钮的图片文字上下居中
 *
 *  @param space 图片和文字的间距
 */
- (void)centerImageAndTitleWithSpace: (CGFloat)space;

/**
 *  设置按钮的图片文字上下居中，默认间距为6.0f
 */
- (void)centerImageAndTitle;

@end
