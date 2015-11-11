//
//  JYHomeProductCell.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/6.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeProductCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageThree;
@property (weak, nonatomic) IBOutlet UILabel *placeNow;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
