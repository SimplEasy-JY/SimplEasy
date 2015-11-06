//
//  JYHomeProductCell.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/6.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYHomeProductCell.h"
@interface JYHomeProductCell ()
@property (weak, nonatomic) IBOutlet UIView *lineOne;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;
@property (weak, nonatomic) IBOutlet UIView *longLine;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bgPrice;


@end
@implementation JYHomeProductCell

- (void)awakeFromNib {
    [self.lineOne.layer setBorderWidth:0.5];
    [self.lineOne.layer setBorderColor:JYLineColor.CGColor];
    [self.lineTwo.layer setBorderWidth:0.5];
    [self.lineTwo.layer setBorderColor:JYLineColor.CGColor];
    [self.longLine.layer setBorderWidth:0.5];
    [self.longLine.layer setBorderColor:JYLineColor.CGColor];
    [self.bottomView.layer setBorderWidth:0.5];
    [self.bottomView.layer setBorderColor:JYLineColor.CGColor];
    self.bottomView.backgroundColor = kRGBColor(240, 240, 240);
    self.bgPrice.backgroundColor = kRGBColor(240, 240, 240);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(selected) {
        [(UIButton *)self.accessoryView setHighlighted:NO];
    }}

@end
