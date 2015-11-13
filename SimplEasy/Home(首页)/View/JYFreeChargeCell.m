//
//  JYFreeChargeCell.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/9.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYFreeChargeCell.h"

@interface JYFreeChargeCell ()
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIButton *leftShopButton;
@property (weak, nonatomic) IBOutlet UIButton *rightShopButton;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftPlaceNow;
@property (weak, nonatomic) IBOutlet UILabel *rightPlaceNow;

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

-(void)setAttribute{
    //图片
    NSString *fImageURL = [NSString stringWithFormat:@"http://www.i-jianyi.com%@",self.firstGoodsItem.pic];
    NSString *sImageURL = [NSString stringWithFormat:@"http://www.i-jianyi.com%@",self.secondGoodsItem.pic];
    //地址
    NSArray *fStrSchool = [self.firstGoodsItem.schoolname componentsSeparatedByString:@"-"];
    NSArray *sStrSchool = [self.secondGoodsItem.schoolname componentsSeparatedByString:@"-"];
    /**  属性设置 */
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:fImageURL]];
    [self.rightImage sd_setImageWithURL:[NSURL URLWithString:sImageURL]];

    self.leftLabel.text = self.firstGoodsItem.name;
    self.rightLabel.text = self.secondGoodsItem.name;
    self.leftPlaceNow.text = [fStrSchool firstObject];
    self.rightPlaceNow.text = [sStrSchool firstObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
