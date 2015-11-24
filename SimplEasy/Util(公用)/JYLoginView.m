//
//  JYLoginView.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/24.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYLoginView.h"
@interface JYLoginView ()
@property(strong,nonatomic)UITextField *userFiled;
@property(strong,nonatomic)UITextField *passFiled;
@end
@implementation JYLoginView
#pragma mark - 懒加载
-(UITextField *)userFiled{
    if (!_userFiled) {
        self.userFiled = [[UITextField  alloc]initWithFrame:CGRectMake(50, kWindowH/2-80, kWindowW-100, 50)];
    }
    return _userFiled;
}
-(UITextField *)passFiled{
    if (!_passFiled) {
        self.passFiled = [[UITextField  alloc]initWithFrame:CGRectMake(50, kWindowH/2, kWindowW-100, 50)];
    }
    return _passFiled;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userFiled.backgroundColor = [UIColor redColor];
        self.passFiled.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.userFiled];
        [self addSubview:self.passFiled];
    }
    return self;
}
//1201909608841


@end
