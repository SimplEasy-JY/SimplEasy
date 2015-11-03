//
//  ViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYHomeController.h"
#import "UIBarButtonItem+Extension.h"
#import "JYProductDetailVC.h"
@interface JYHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setNav];
    [self setupTableView];

}


-(void)initData{

}
-(void)setNav{
    //中间的搜索条
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    /**  设置自定义搜索图片 */
    [searchBar setImage:[UIImage imageNamed:@"topicon_3"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
#warning 后台数据替换
    searchBar.placeholder = @"简易破蛋日全场大甩卖";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

-(void)setupTableView{
    //下拉刷新
    DGElasticPullToRefreshLoadingViewCircle *loadingView = [DGElasticPullToRefreshLoadingViewCircle new];
    loadingView.tintColor = [UIColor redColor];
    [self.tableView dg_addPullToRefreshWithActionHandler:^{
        YSHLog(@"下拉刷新");
        [self.tableView dg_stopLoading];
    } loadingView:loadingView];
    [self.tableView dg_setPullToRefreshBackgroundColor:[UIColor blueColor]];
    [self.tableView dg_setPullToRefreshFillColor:[UIColor yellowColor]];
    
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    JYProductDetailVC *productDetailVC = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"JYProductDetailVC"];
    productDetailVC.title = @"商品详情";
    [self.navigationController pushViewController:productDetailVC animated:YES];
}
@end
