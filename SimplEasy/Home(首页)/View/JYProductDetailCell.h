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
@property (nonatomic, strong) UILabel *productDescLb;
/** 现在的价格 */
@property (nonatomic, strong) UILabel *currentPriceLb;
/** 原价 */
@property (nonatomic, strong) UILabel *originPriceLb;
/** 发布时间（几分钟前） */
@property (nonatomic, strong) UILabel *publishTimeLb;
/** 发布地点 */
@property (nonatomic, strong) UILabel *placeLb;
/** 分享按钮 */
@property (nonatomic, strong) UIButton *shareBtn;





@end
