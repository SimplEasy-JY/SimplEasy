//
//  UIButton+VerticalBtn.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/16.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "UIButton+VerticalBtn.h"

@implementation UIButton (VerticalBtn)

- (void)centerImageAndTitleWithSpace: (CGFloat)space{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = imageSize.height + titleSize.height + space;
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight-imageSize.height), 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight-titleSize.height), 0.0);
}

- (void)centerImageAndTitle{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitleWithSpace:DEFAULT_SPACING];
}

@end
