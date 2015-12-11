//
//  JYFactory.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFactory : NSObject
/** 向某个控制器上，添加菜单按钮 */
//+ (void)addMenuItemToVC:(UIViewController *)vc;

/** 向某个控制器上，添加返回按钮 */
+ (void)addBackItemToVC:(UIViewController *)vc;
@end
