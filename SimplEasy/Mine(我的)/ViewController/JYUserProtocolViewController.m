//
//  JYUserProtocolViewController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/25.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYUserProtocolViewController.h"

@interface JYUserProtocolViewController ()
@end

@implementation JYUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JYWhite;
    //取消按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 25, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:JYGlobalBg forState:UIControlStateNormal];
    [button setTitleColor:kRGBColor(200, 200, 200) forState:UIControlStateHighlighted];
    [button bk_addEventHandler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, kWindowW-120, 60)];
    label.text = @"温馨提示:注意交易安全！";
    [self.view addSubview:button];
    [self.view addSubview:label];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
