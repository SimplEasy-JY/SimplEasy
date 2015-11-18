//
//  JYProductDetailVC.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//  商品详情VC

#import <UIKit/UIKit.h>

@interface JYProductDetailVC : UIViewController

@property(strong,nonatomic)NSString *goodsID;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSArray *pics;

@end
