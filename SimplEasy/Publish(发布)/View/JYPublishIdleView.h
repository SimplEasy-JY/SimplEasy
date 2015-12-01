//
//  JYPublishIdleView.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/1.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYPublishIdleView : UIView <UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 标题TF */
@property (nonatomic, strong) UITextField *titleTF;
/** 商品描述TV */
@property (nonatomic, strong) UITextView *descTV;
/** 按钮图片 */
@property (nonatomic, strong) UIButton *imageBtn;
/** 定位按钮 */
@property (nonatomic, strong) UIButton *locationBtn;
/** 价格TF */
@property (nonatomic, strong) UITextField *priceTF;
/** 原价TF */
@property (nonatomic, strong) UITextField *originPriceTF;
/** 分类TF */
@property (nonatomic, strong) UITextField *classTF;
/** 发布按钮 */
@property (nonatomic, strong) UIButton *publishBtn;

@end
