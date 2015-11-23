//
//  JYRecommendCell.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/9.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYRecommendCell.h"
#import "JYProductDetailVC.h"

#import "UILabel+Line.h"
@interface JYRecommendCell ()
@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeNow;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@end
@implementation JYRecommendCell

- (void)awakeFromNib {
    /**  颜色 边框 设置 */
    [self.shopLabel.layer setBorderWidth:2];
    [self.shopLabel.layer setBorderColor:kRGBColor(0, 182, 0).CGColor];
    [self.shopLabel setTextColor:kRGBColor(0, 182,0)];
    self.placeNow.textColor = kRGBColor(158, 207, 242);
    self.currentPrice.textColor = kRGBColor(189, 33, 33);
    self.originalPrice.textColor = kRGBColor(152, 152, 152);
    self.describeLabel.textColor = kRGBColor(102, 102, 102);
    [self.originalPrice addMidLine];
    
    
}
-(void)setAttribute{
    //图片
    NSString *imageURL = [NSString stringWithFormat:@"http://www.i-jianyi.com%@",self.goodsItems.pic];
    //地址
    NSArray *strSchool = [self.goodsItems.schoolname componentsSeparatedByString:@"-"];
    //时间
    /**  属性设置 */
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    self.describeLabel.text = self.goodsItems.name;
    self.currentPrice.text = [NSString stringWithFormat:@"￥%@",self.goodsItems.price];
    self.placeNow.text = [strSchool firstObject];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
