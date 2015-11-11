//
//  JYFreeChargeCell.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/9.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYFreeChargeCell.h"

@interface JYFreeChargeCell ()
@property (weak, nonatomic) IBOutlet UIView *leftBgView;
@property (weak, nonatomic) IBOutlet UIView *rightBgView;

@end
@implementation JYFreeChargeCell

- (void)awakeFromNib {
    self.leftBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.25];
    self.rightBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.25];
    [self.leftButton bk_addEventHandler:^(id sender) {
        NSLog(@"leftButtonClick~");
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
