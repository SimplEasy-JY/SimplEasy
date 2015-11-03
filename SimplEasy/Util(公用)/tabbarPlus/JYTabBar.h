//
//  JYTabBar.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYTabBar;
#warning 因为JYTabBar继承自UITabBar，所以称为JYTabBar的代理，也必须实现UITabBar的代理协议
@protocol JYTabBarDelegate <UITabBarDelegate>
/**  可选择实现的方法 */
@optional
- (void)tabBarDidClickPlusButton:(JYTabBar *)tabBar;
@end

@interface JYTabBar : UITabBar
@property (nonatomic, weak) id<JYTabBarDelegate> delegate;

@end
