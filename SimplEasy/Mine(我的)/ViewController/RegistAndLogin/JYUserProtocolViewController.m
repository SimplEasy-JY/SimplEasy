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
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:JYGlobalBg forState:UIControlStateNormal];
    [button setTitleColor:kRGBColor(200, 200, 200) forState:UIControlStateHighlighted];
    [button bk_addEventHandler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, kWindowW-60,kWindowH-100)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"用户须知\n\n\n为维持简易平台的和谐秩序，在使用简易前，请您仔细阅读以下内容：\n致卖家---七不准则\n不频繁重复地发布垃圾广告、兼职广告等\n不发布虚假信息\n不发布代购商品、淘宝店、微商等大量信息\n（如需推广，请私信简易，欢迎合作）\n不进行骗取他人财务的欺诈行为\n不恶意发布他人照片、信息等进行人身攻击\n不发布黄色、反动、暴力以及政治敏感等信息\n不发布国家不允许的违禁商品信息\n致买家----一个提醒\n由于交易时线下交易，时间地点请慎重选择，注意人身财产安全。请当面验货，如需物流，自行与卖家商洽\n*双方均需遵守诚信交易的原则，如有问题，可与简易联系。";
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
