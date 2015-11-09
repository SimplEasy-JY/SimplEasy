//
//  JYRecommendCell.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/9.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYRecommendCell.h"

@implementation JYRecommendCell

- (void)awakeFromNib {
    /**  颜色 边框 设置 */
    [self.shopButton.layer setBorderWidth:1.5];
    [self.shopButton.layer setBorderColor:kRGBColor(130, 198, 88).CGColor];
    [self.shopButton setTintColor:kRGBColor(130, 198, 88)];
    self.placeNow.textColor = kRGBColor(158, 207, 242);
    self.currentPrice.textColor = kRGBColor(189, 33, 33);
    self.originalPrice.textColor = kRGBColor(152, 152, 152);
    self.describeLabel.textColor = kRGBColor(102, 102, 102);
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
