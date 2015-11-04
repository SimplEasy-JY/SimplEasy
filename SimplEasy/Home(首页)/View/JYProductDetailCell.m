//
//  JYProductDetailCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductDetailCell.h"

@interface JYProductDetailCell ()
@property (weak, nonatomic) IBOutlet UIView *timeAndPlaceView;

@end

@implementation JYProductDetailCell

- (void)awakeFromNib {
    self.timeAndPlaceView.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
