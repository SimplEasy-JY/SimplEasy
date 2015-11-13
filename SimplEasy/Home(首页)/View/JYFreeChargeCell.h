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

//@property(assign,nonatomic)NSInteger firstGoodsId;
//@property(assign,nonatomic)NSInteger secondGoodsId;
@property(strong,nonatomic)JYGoodsItems *firstGoodsItem;
@property(strong,nonatomic)JYGoodsItems *secondGoodsItem;

-(void)setAttribute;
@end
