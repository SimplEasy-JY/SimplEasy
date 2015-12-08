//
//  JYTitleCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYTitleCell.h"
/** 间隔 */
static const CGFloat MARGIN = 10;

@implementation JYTitleCell

- (UITextField *)titleTF {
    if(_titleTF == nil) {
        _titleTF = [[UITextField alloc] init];
        [self.contentView addSubview:_titleTF];
        [_titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.top.bottom.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.right.mas_equalTo(-MARGIN);
        }];
        _titleTF.placeholder = @"标题";
        _titleTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _titleTF;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self titleTF];
    return self;
}

@end
