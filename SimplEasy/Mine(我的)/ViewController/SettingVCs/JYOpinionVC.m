//
//  JYOpinionVC.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/14.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYOpinionVC.h"
#import "JYUserInfoNetManager.h"
#import "JYNormalModel.h"

@interface JYOpinionVC ()
/** textview */
@property (nonatomic, strong) UITextView *opinionTV;
@end

@implementation JYOpinionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(236, 236, 236);
    [JYFactory addBackItemToVC:self];
    [self configOpinionView];
}


- (void)configOpinionView{
    UITextView *opinionTV = [[UITextView alloc] init];
    self.opinionTV = opinionTV;
    opinionTV.text = @"您的宝贵意见我们都会采纳哦!";
    [self.view addSubview:opinionTV];
    [opinionTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    //为TExtView加一个手势，下滑回收键盘
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [opinionTV resignFirstResponder];
    }];
    swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [opinionTV addGestureRecognizer:swipeGR];
    
    UIButton *sendOpinionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendOpinionBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [sendOpinionBtn setBackgroundColor:JYGlobalBg];
    [sendOpinionBtn addTarget:self action:@selector(pullOpinion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendOpinionBtn];
    [sendOpinionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)pullOpinion: (UIButton *)button{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    [JYUserInfoNetManager sendOpinionWithUserID:userId.integerValue opinionContent:self.opinionTV.text completionHandle:^(JYNormalModel *model, NSError *error) {
        if (model.status.integerValue == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"反馈成功，谢谢您的反馈，简易会因您越来越好！" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message: model.errorMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"不反馈了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentViewController:alert animated:YES completion:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"再来一次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.opinionTV becomeFirstResponder];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
