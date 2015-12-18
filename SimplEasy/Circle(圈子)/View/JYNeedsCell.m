//
//  JYNeedsCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/16.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYNeedsCell.h"
#import "JYNeedsPopView.h"


static const CGFloat HEAD_WH = 40;
static const CGFloat PADDING = 5;
static const CGFloat MARGIN = 10;

@interface JYNeedsCell ()

@property (nonatomic, strong)JYNeedsPopView *popView;

@end

@implementation JYNeedsCell

- (UIImageView *)headImg{
    if (_headImg == nil) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.cornerRadius = HEAD_WH/2;
        _headImg.clipsToBounds = YES;
        [self.contentView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLb.mas_bottom).mas_equalTo(MARGIN);
            make.left.mas_equalTo(MARGIN);
            make.size.mas_equalTo(CGSizeMake(HEAD_WH, HEAD_WH));
            make.bottom.mas_equalTo(-MARGIN);
        }];
    }
    return _headImg;
}

- (JYNeedsPopView *)popView{
    if (!_popView) {
        _popView = [[JYNeedsPopView alloc] init];
        _popView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_popView];
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImg.mas_right).mas_equalTo(0);
            make.centerY.mas_equalTo(self.headImg.mas_centerY);
            make.right.mas_lessThanOrEqualTo(-MARGIN);
        }];
    }
    return _popView;
}

- (UILabel *)needsLb{
    if (!_needsLb) {
        _needsLb = [[UILabel alloc] init];
        _needsLb.numberOfLines = 2;
        _needsLb.font = [UIFont systemFontOfSize:14];
        self.popView.lineColor = self.urgent?[UIColor redColor]:[UIColor lightGrayColor];
        [self.popView addSubview:_needsLb];
        [_needsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(MARGIN, 27, MARGIN, MARGIN));
        }];
    }
    return _needsLb;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.textAlignment = NSTextAlignmentCenter;
        _timeLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(PADDING);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return _timeLb;
}



- (void)prepareForReuse{
    [self.popView setNeedsDisplay];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = kRGBColor(236, 236, 236);//圈圈的背景依据这个设置
    self.contentView.backgroundColor = kRGBColor(236, 236, 236);
    return self;
}

@end
