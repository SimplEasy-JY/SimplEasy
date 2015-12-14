//
//  JYUserPublishItemCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/14.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYUserPublishItemCell.h"

static CGFloat MARGIN = 8.0;
static CGFloat GAP = 2.0;
static CGFloat FONT_SIZE = 14.0;
@implementation JYUserPublishItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self idleNum];
    [self needsNum];
    [self friendNum];
    [self idleBtn];
    [self needsBtn];
    [self friendBtn];
    return self;
}

- (UILabel *)idleNum {
    if(_idleNum == nil) {
        _idleNum = [[UILabel alloc] init];
        _idleNum.font = [UIFont systemFontOfSize:FONT_SIZE];
        _idleNum.textAlignment = NSTextAlignmentCenter;
        _idleNum.text = @"0";
        [self.contentView addSubview:_idleNum];
        [_idleNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MARGIN);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(-GAP);
            make.width.mas_equalTo(self.contentView.width/3);
        }];
    }
    return _idleNum;
}

- (UILabel *)needsNum {
    if(_needsNum == nil) {
        _needsNum = [[UILabel alloc] init];
        _needsNum.text = @"0";
        _needsNum.font = [UIFont systemFontOfSize:FONT_SIZE];
        _needsNum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_needsNum];
        [_needsNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MARGIN);
            make.left.mas_equalTo(self.idleNum.mas_right).mas_equalTo(0);
            make.bottom.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(-GAP);
            make.width.mas_equalTo(self.contentView.width/3);
        }];
    }
    return _needsNum;
}

- (UILabel *)friendNum {
    if(_friendNum == nil) {
        _friendNum = [[UILabel alloc] init];
        _friendNum.text = @"0";
        _friendNum.font = [UIFont systemFontOfSize:FONT_SIZE];
        _friendNum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_friendNum];
        [_friendNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MARGIN);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(-GAP);
            make.width.mas_equalTo(self.contentView.width/3);
        }];
    }
    return _friendNum;
}

- (UIButton *)idleBtn {
    if(_idleBtn == nil) {
        _idleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _idleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [_idleBtn setTitle:@"闲置" forState:UIControlStateNormal];
        [_idleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_idleBtn setTitleColor:JYGlobalBg forState:UIControlStateHighlighted];
        [self.contentView addSubview:_idleBtn];
        [_idleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(GAP);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-MARGIN);
            make.width.mas_equalTo(self.contentView.width/3);
        }];
    }
    return _idleBtn;
}

- (UIButton *)needsBtn {
    if(_needsBtn == nil) {
        _needsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _needsBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [_needsBtn setTitle:@"需求" forState:UIControlStateNormal];
        [_needsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_needsBtn setTitleColor:JYGlobalBg forState:UIControlStateHighlighted];
        [self.contentView addSubview:_needsBtn];
        [_needsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(GAP);
            make.left.mas_equalTo(self.idleBtn.mas_right).mas_equalTo(0);
            make.bottom.mas_equalTo(-MARGIN);
            make.width.mas_equalTo(self.contentView.width/3);
        }];
    }
    return _needsBtn;
}

- (UIButton *)friendBtn {
    if(_friendBtn == nil) {
        _friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _friendBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [_friendBtn setTitle:@"易友" forState:UIControlStateNormal];
        [_friendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_friendBtn setTitleColor:JYGlobalBg forState:UIControlStateHighlighted];
        [self.contentView addSubview:_friendBtn];
        [_friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(GAP);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-MARGIN);
            make.width.mas_equalTo(self.contentView.width/3);
        }];
    }
    return _friendBtn;
}

@end
