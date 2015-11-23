//
//  JYPlusButton.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPlusButton.h"


@interface JYPlusButton ()

@end
@implementation JYPlusButton

+(void)load{
    [super registerSubclass];
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}


//上下结构的 button
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 控件大小,间距大小
    CGFloat const imageViewEdge   = self.bounds.size.width * 0.6;
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdge;
    CGFloat const verticalMargin  = verticalMarginT / 2;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdge * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdge  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
    //imageView position 位置
    
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdge, imageViewEdge);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
    self.titleLabel.tintColor = [UIColor orangeColor];
}

#pragma mark -
#pragma mark - Public Methods
/*
 *
 Create a custom UIButton with title and add it to the center of our tab bar
 *
 */
+ (instancetype)plusButton{
    
    JYPlusButton *button = [[JYPlusButton alloc]init];
    
    [button setImage:[UIImage imageNamed:@"bottom_plus"] forState:UIControlStateNormal];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
    [button sizeToFit];
    
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}



#pragma mark -
#pragma mark - Event Response

- (void)clickPublish {
    RESideMenu *menu = rootVC.sideMenu;
    UITabBarController *tabBarController = (UITabBarController *)menu.contentViewController;
//    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIViewController *viewController = tabBarController.selectedViewController;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //    UIAlertAction
    
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
    //                                                            delegate:nil
    //                                                   cancelButtonTitle:@"取消"
    //                                              destructiveButtonTitle:nil
    //                                                   otherButtonTitles:@"发布闲置", @"随便说说", @"活动求组", nil];
    //    [actionSheet showInView:viewController.view];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"000000000");
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"发布闲置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"11111111111");
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"随便说说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"2222222");
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"活动求组" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"33333333");
    }]];
    
    [viewController presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %ld", buttonIndex);
}

//+ (NSUInteger)indexOfPlusButtonInTabBar {
//    return 3;
//}

+ (CGFloat)multiplerInCenterY {
    return  0.23;
}


@end
