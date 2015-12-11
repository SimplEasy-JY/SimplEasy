//
//  JYWebViewController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYWebViewController.h"

@interface JYWebViewController ()<UIWebViewDelegate>
@property(strong,nonatomic)UIWebView *webView ;
@property(strong,nonatomic)UIActivityIndicatorView *loadingView;

@end

@implementation JYWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    /**  设置view的背景颜色 */
    self.view.backgroundColor = YSHGlobalBg;
    /**  先隐藏webView */
    self.webView.hidden = YES;
//    self.webView.backgroundColor = [UIColor redColor];
    [JYFactory addBackItemToVC:self];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
   
    [self.loadingView startAnimating];
    
    
}



#pragma mark  -UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //显示webview
    webView.hidden = NO;
    //隐藏正在加载
    [self.loadingView stopAnimating];
    YSHLog(@"1111111");
    
}
#pragma -mark 懒加载
-(UIWebView *)webView{
    if (!_webView) {
        _webView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _webView;
    
}
-(UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        self.loadingView = [[UIActivityIndicatorView  alloc]init];
        [self.view addSubview:_loadingView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
    }
    return _loadingView;
    
}
@end
