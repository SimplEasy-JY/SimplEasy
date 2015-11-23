//
//  JYClassifyCell.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/21.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYClassifyCell : UITableViewCell

/** 商品图片 */
@property (nonatomic, strong) UIImageView *productIV;
/** 商品描述 */
@property (nonatomic, strong) UILabel *productDesc;
/** 现在的价格 */
@property (nonatomic, strong) UILabel *currentPrice;
/** 原始价格 */
@property (nonatomic, strong) UILabel *originPrice;
/** 定位图标 */
@property (nonatomic, strong) UIImageView *locationIV;
/** 学校名称 */
@property (nonatomic, strong) UILabel *schoolNameLb;
/** 发布日期 */
@property (nonatomic, strong) UILabel *publishDateLb;


@end
