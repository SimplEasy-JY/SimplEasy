//
//  JYProductDetailCell.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYProductDetailCell : UITableViewCell
/** 商品描述 */
@property (weak, nonatomic) IBOutlet UILabel *productDescLb;
/** 现在的价格 */
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLb;
/** 原价 */
@property (weak, nonatomic) IBOutlet UILabel *originPriceLb;
/** 发布时间（几分钟前） */
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLb;
/** 发布地点 */
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
/** 分享按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end
