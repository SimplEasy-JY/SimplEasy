//
//  JYTextView.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/14.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYTextView.h"

@interface JYTextView () <UITextViewDelegate>

/** 背景TV */
@property (nonatomic, strong) UITextView *backTV;

@end

@implementation JYTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backTV.frame = self.frame;
        [self.backTV addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        self.delegate = self;
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _backTV.text = placeholder;
}

@end
