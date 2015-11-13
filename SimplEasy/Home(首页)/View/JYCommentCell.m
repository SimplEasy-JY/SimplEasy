//
//  JYCommentCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYCommentCell.h"

@implementation JYCommentCell

- (UIImageView *)headIV {
    if(_headIV == nil) {
        _headIV = [[UIImageView alloc] init];
        _headIV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_headIV];
        [_headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _headIV;
}

- (UILabel *)nickNameLb {
    if(_nickNameLb == nil) {
        _nickNameLb = [[UILabel alloc] init];
        _nickNameLb.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nickNameLb];
        [_nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headIV.mas_right).mas_equalTo(10);
            make.bottom.mas_equalTo(self.headIV.mas_centerY).mas_equalTo(-5);
        }];
    }
    return _nickNameLb;
}

- (UILabel *)timeLb {
    if(_timeLb == nil) {
        _timeLb = [[UILabel alloc] init];
        _timeLb.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nickNameLb.mas_left);
            make.top.mas_equalTo(self.headIV.mas_centerY).mas_equalTo(5);
        }];
    }
    return _timeLb;
}

- (UIImageView *)rankIV {
    if(_rankIV == nil) {
        _rankIV = [[UIImageView alloc] init];
        [self.contentView addSubview:_rankIV];
        [_rankIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.nickNameLb.mas_centerY);
            make.width.height.mas_equalTo(16);
            make.left.mas_equalTo(self.nickNameLb.mas_right).mas_equalTo(5);
        }];
    }
    return _rankIV;
}

- (UILabel *)commentLb {
    if(_commentLb == nil) {
        _commentLb = [[UILabel alloc] init];
        _commentLb.font = [UIFont systemFontOfSize:16];
        _commentLb.numberOfLines = 0;
        [self.contentView addSubview:_commentLb];
        [_commentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headIV.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(self.contentView).mas_equalTo(10);
            make.right.mas_equalTo(self.contentView).mas_equalTo(-10);
            make.bottom.mas_equalTo(self.contentView).mas_equalTo(-10);
        }];
        
    }
    return _commentLb;
}

- (UIButton *)goodBtn {
    if(_goodBtn == nil) {
        _goodBtn = [[UIButton alloc] init];
        _goodBtn.tintColor = [UIColor darkGrayColor];
        _goodBtn.titleLabel.textColor = [UIColor darkGrayColor];
        _goodBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_goodBtn setImage:[UIImage imageNamed:@"middleicon_34"] forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"middleicon_41"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_goodBtn];
        [_goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_equalTo(-10);
            make.centerY.mas_equalTo(self.headIV.mas_centerY);
        }];
    }
    return _goodBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
}
@end
