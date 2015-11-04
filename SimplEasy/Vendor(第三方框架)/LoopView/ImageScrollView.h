//
//  ImageScrollView.h
//  smgui
//
//  Created by 杨胜浩 on 15/5/25.
//  Copyright (c) 2015年 yangshenghao. All rights reserved.
//
/**
 *轮播view
 *
 */
#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>


-(void)didSelectImageAtIndex:(NSInteger)index;

@end

@interface ImageScrollView : UIView

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) NSArray *imgArray;
@property(nonatomic, assign) id<ImageScrollViewDelegate> delegate;

//-(void)setImageArray:(NSArray *)imageArray;
-(ImageScrollView *)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray;


@end
