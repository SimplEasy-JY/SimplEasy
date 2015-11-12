//
//  JYSellerCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYSellerCell.h"

@interface JYSellerCell ()

/** 加关注 */
@property (nonatomic, strong) UIButton *followBtn;

@end

@implementation JYSellerCell

- (UIImageView *)headIV {
    if(_headIV == nil) {
        _headIV = [[UIImageView alloc] init];
        _headIV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_headIV];
        [_headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
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
            make.bottom.mas_equalTo(self.headIV.mas_centerY);
        }];
    }
    return _nickNameLb;
}

- (UILabel *)schoolLb {
    if(_schoolLb == nil) {
        _schoolLb = [[UILabel alloc] init];
        _schoolLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_schoolLb];
        [_schoolLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nickNameLb.mas_left);
            make.top.mas_equalTo(self.headIV.mas_centerY);
        }];
    }
    return _schoolLb;
}

- (UIImageView *)rankIV {
    if(_rankIV == nil) {
        _rankIV = [[UIImageView alloc] init];
        [self.contentView addSubview:_rankIV];
        [_rankIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nickNameLb.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(self.nickNameLb);
            make.width.height.mas_equalTo(16);
        }];
    }
    return _rankIV;
}

- (UIButton *)followBtn {
    if(_followBtn == nil) {
        _followBtn = [[UIButton alloc] init];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followBtn setImage:[UIImage imageNamed:@"middleicon_03"] forState:UIControlStateNormal];
        [self.contentView addSubview:_followBtn];
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.headIV);
            make.right.mas_equalTo(-10);
            make.height.width.mas_equalTo(40);
        }];
    }
    return _followBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.followBtn.selected = NO;
    return self;
}


@end
