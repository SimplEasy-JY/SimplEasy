//
//  JYProductDescCell.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYProductDescCell : UITableViewCell <UITextViewDelegate>

/** 商品描述TV */
@property (nonatomic, strong) UITextView *descTV;
/** 放图片的scrollView */
@property (nonatomic, strong) UIScrollView *imageScrollView;
/** 图片提示Label */
@property (nonatomic, strong) UILabel *imageNoticeLb;

@end
