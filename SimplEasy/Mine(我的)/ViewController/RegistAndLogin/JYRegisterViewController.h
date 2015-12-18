//
//  JYRegisterViewController.h
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/25.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYLoginViewController.h"
@interface JYRegisterViewController : UIViewController
//接受手机号
@property(strong,nonatomic)NSString *phoneNum;
@property(strong,nonatomic)JYLoginViewController *lvc;
@end
