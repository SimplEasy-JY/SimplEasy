//
//  JYTabBar.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYTabBar.h"
#import "JYPlusButton.h"
@interface JYTabBar ()
/**  自定义tabbar中的加号按钮 */
@property(weak,nonatomic)JYPlusButton *plusBtn;
@end
@implementation JYTabBar
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //添加一个按钮到tabbar中
        JYPlusButton *plusBtn = [[JYPlusButton alloc]init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"bottom_plus"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"bottom_plus"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
    
}

/**  加号按钮的点击 */
-(void)plusClick{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}
/**  自动布局 */
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //1.设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5-50;
    
    //2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIndex = 0 ;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            //宽度
            child.width = tabbarButtonW;
            //设置x
            child.x = tabbarButtonIndex * tabbarButtonW;
            
            //增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex ++ ;
            }
            
        }
    }
}

@end
