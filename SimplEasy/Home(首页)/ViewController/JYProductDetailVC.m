//
//  JYProductDetailVC.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductDetailVC.h"
#import "ScrollDisplayViewController.h"
//#import "JYProductDetailCell.h"
//#import "JYSellerCell.h"
//#import "JYCommentCell.h"

@interface JYProductDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ScrollDisplayViewController *sdVC;
@end

@implementation JYProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableViewHeader];
}

- (void)configTableViewHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 320)];
    [self.sdVC removeFromParentViewController];
    
    self.sdVC = [[ScrollDisplayViewController alloc] initWithImageNames:@[@"picture_15",@"picture_17",@"picture_19"]];
    self.sdVC.pageIndicatorTintColor = [UIColor blackColor];
    self.sdVC.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.sdVC.pageControlOffset = 10;
    [self addChildViewController:self.sdVC];
    [headerView addSubview:self.sdVC.view];
    [self.sdVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    self.tableView.tableHeaderView = headerView;
    
    
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailCell"];
        }else if (indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"SellerCell"];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    }
    
    
    return cell;
    
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
