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

- (UILabel *)needsLb{
    if (!_needsLb) {
        _needsLb = [[UILabel alloc] init];
        self.popView.lineColor = self.urgent?[UIColor redColor]:[UIColor lightGrayColor];
        [self.popView addSubview:_needsLb];
        [_needsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(27);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-10);
        }];
    }
    return _needsLb;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27);
            make.top.mas_equalTo(5);
        }];
    }
    return _timeLb;
}

- (JYNeedsPopView *)popView{
    if (!_popView) {
        _popView = [[JYNeedsPopView alloc] init];
        _popView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_popView];
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLb.mas_bottom).mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-5);
        }];
    }
    return _popView;
}

- (void)prepareForReuse{
    [self.popView setNeedsDisplay];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.contentView.backgroundColor = kRGBColor(236, 236, 236);
    return self;
}

@end
