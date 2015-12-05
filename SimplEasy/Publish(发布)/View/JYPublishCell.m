//
//  JYPublishCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPublishCell.h"

@implementation JYPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self publishBtn];
    return self;
}

- (UIButton *)publishBtn {
    if(_publishBtn == nil) {
        _publishBtn = [[UIButton alloc] init];
        [_publishBtn setBackgroundColor:JYGlobalBg];
        [_publishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
        [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_publishBtn];
        [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    return _publishBtn;
}
@end
