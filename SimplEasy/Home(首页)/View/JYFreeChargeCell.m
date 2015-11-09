//
//  JYFreeChargeCell.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/9.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYFreeChargeCell.h"
#import "JYChargeCell.h"
@interface JYFreeChargeCell ()
@end
@implementation JYFreeChargeCell

- (void)awakeFromNib {
    JYChargeCell *cell = [[JYChargeCell alloc]init];
    [self.contentView addSubview:cell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
