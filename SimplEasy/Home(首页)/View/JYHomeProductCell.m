//
//  JYHomeProductCell.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/6.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYHomeProductCell.h"
#import "UIImage+Circle.h"
#import "UILabel+Line.h"
@interface JYHomeProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *placeNow;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineOne;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;
@property (weak, nonatomic) IBOutlet UIView *longLine;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bgPrice;
@property (weak, nonatomic) IBOutlet UIButton *userButton;



@end
@implementation JYHomeProductCell

- (void)awakeFromNib {
    /**  颜色 边框 设置 */
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
    self.time.textColor = kRGBColor(152, 152, 152);
    self.currentPrice.textColor = kRGBColor(190, 44, 44);
    self.describeLabel.textColor = kRGBColor(102, 102, 102);
    self.placeNow.textColor = kRGBColor(153, 204, 242);
    [self.userButton bk_addEventHandler:^(id sender) {
        YSHLog(@"点击了用户头像");
    } forControlEvents:UIControlEventTouchUpInside];
   
}

-(void)setAttribute{
    //先隐藏图片，防止加载成圆形前出现方形图
    self.userImageView.hidden = YES;
    //图片
    NSString *imageURL = [NSString stringWithFormat:@"http://wx.i-jianyi.com%@",self.goodsItems.pic];

    //时间
    NSArray *strTime = [self.goodsItems.time componentsSeparatedByString:@" "];
    NSString *time = [strTime[0] substringFromIndex:5];
    /**  属性设置 */
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsItems.headImg] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
             UIImage *image = [UIImage circleImageWithImage:self.userImageView.image borderWidth:0.5 borderColor:[UIColor whiteColor]];
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.userImageView.image = image;
                 self.userImageView.hidden = NO;
             });
         });
    }];
    self.shopImage.contentMode = 2;
    self.shopImage.clipsToBounds = YES;
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    
    self.userName.text = self.goodsItems.username;
    self.describeLabel.text = self.goodsItems.name;
    self.currentPrice.text = [NSString stringWithFormat:@"￥%@ ",self.goodsItems.price];
    self.time.text = time;
    self.placeNow.text = self.goodsItems.schoolname ;
    if (!self.originalPrice) {
        [self.originalPrice addMidLine];
    }
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(selected) {
        [(UIButton *)self.accessoryView setHighlighted:NO];
    }}

@end
