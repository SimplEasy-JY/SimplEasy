//
//  JYRecommendCell.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/9.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYGoodsModel.h"
@interface JYRecommendCell : UITableViewCell

@property(strong,nonatomic)JYGoodsItems *goodsItems;

-(void)setAttribute;

@end
