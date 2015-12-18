//
//  JYNormalCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYNormalCell.h"

static const CGFloat BADGE_HW = 12;

@implementation JYNormalCell

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)removeBadge{
    self.accessoryView = nil;
}

- (void)setBadge: (NSInteger)value{
    self.accessoryView = [UIView new];
    UILabel *label = [[UILabel alloc] init];
    [self.accessoryView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        if (value == 0) {
            make.size.mas_equalTo(CGSizeMake(BADGE_HW/2, BADGE_HW/2));
        }else{
            make.size.mas_equalTo(CGSizeMake(BADGE_HW, BADGE_HW));
        }
    }];
    label.backgroundColor = JYGlobalBg;
    label.layer.cornerRadius = value == 0?BADGE_HW/4:BADGE_HW/2;
    label.clipsToBounds = YES;
    label.font = [UIFont systemFontOfSize:BADGE_HW-2];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = (value == 0)?@"":[NSString stringWithFormat:@"%lu",value];
}
@end
