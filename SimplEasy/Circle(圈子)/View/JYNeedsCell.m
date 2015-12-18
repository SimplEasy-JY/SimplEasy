//
//  JYNeedsCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/16.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYNeedsCell.h"
#import "JYNeedsPopView.h"


@interface JYNeedsCell ()

@property (nonatomic, strong)JYNeedsPopView *popView;

@end

@implementation JYNeedsCell

- (UIImageView *)headImg{
    if (_headImg == nil) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.cornerRadius = 30;
        _headImg.clipsToBounds = YES;
        [self.contentView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLb.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.bottom.mas_equalTo(-5);
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
            make.right.mas_lessThanOrEqualTo(-10);
        }];
    }
    return _popView;
}

- (UILabel *)needsLb{
    if (!_needsLb) {
        _needsLb = [[UILabel alloc] init];
        _needsLb.numberOfLines = 2;
        self.popView.lineColor = self.urgent?[UIColor redColor]:[UIColor lightGrayColor];
        [self.popView addSubview:_needsLb];
        [_needsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 27, 10, 10));
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
            make.top.mas_equalTo(5);
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
