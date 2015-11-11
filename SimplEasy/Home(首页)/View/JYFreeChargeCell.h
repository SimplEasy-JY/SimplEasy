//
//  JYFreeChargeCell.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/9.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYFreeChargeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIButton *leftShopButton;
@property (weak, nonatomic) IBOutlet UIButton *rightShopButton;
@property (weak, nonatomic) IBOutlet UILabel *letfLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property(assign,nonatomic)NSInteger goodsId;

@end
