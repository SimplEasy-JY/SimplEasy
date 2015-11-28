//
//  UILabel+Line.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/12.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "UILabel+Line.h"

@implementation UILabel (Line)

- (void)addMidLine{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attribtDic];
        self.attributedText = attributStr;
    });

    
    
}

- (void)addBottomLine{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attribtDic];
    self.attributedText = attributStr;
}

@end