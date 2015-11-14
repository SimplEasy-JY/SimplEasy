//
//  JYFreeChargeCell.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/9.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYGoodsModel.h"
@interface JYFreeChargeCell : UITableViewCell

/**  传控制器 */
@property(strong,nonatomic)id rootController;
@property(strong,nonatomic)JYGoodsItems *firstGoodsItem;
@property(strong,nonatomic)JYGoodsItems *secondGoodsItem;

-(void)setAttribute;
@end
