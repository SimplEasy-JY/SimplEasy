//
//  JYClassifyContentVC.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/21.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassifyContentVC.h"
#import "JYClassifyCell.h"
#import "JYProductInfoViewModel.h"
#import "JYProductDetailVC.h"

static NSString *cellIdentifier = @"Cell";
static CGFloat sectionHeaderH = 30.0;


@interface JYClassifyContentVC ()<UITableViewDelegate,UITableViewDataSource>

/** 表格视图 */
@property (nonatomic, strong) UITableView *tableView;

/** 商品视图控制器 */
@property (nonatomic, strong) JYProductInfoViewModel *productInfoVM;
/** 排序（子分类）*/
@property (nonatomic, strong) NSString *sort;

@end

@implementation JYClassifyContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sort = @"all";
    self.tableView.dataSource = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.productInfoVM refreshDataCompletionHandle:^(NSError *error) {
            if (error) {
                JYLog(@"刷新出错: %@",error.description);
                [self.tableView.header endRefreshing];
            }
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }];
    }];
    
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.productInfoVM getMoreDataCompletionHandle:^(NSError *error) {
            if (error) {
                JYLog(@"获取更多出错: %@",error.description);
                [self.tableView.footer endRefreshing];
            }
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
        }];
    }];
}


#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.productInfoVM rowNum];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell.productIV sd_setImageWithURL:[self.productInfoVM imageURLForRow:indexPath.row]];
    cell.productDesc.text = [self.productInfoVM productDescForRow:indexPath.row];
    cell.currentPrice.text = [self.productInfoVM currentPriceForRow:indexPath.row];
    cell.schoolNameLb.text = [self.productInfoVM schoolNameForRow:indexPath.row];
    cell.publishDateLb.text = [self.productInfoVM publishTimeForRow:indexPath.row];
    
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sectionHeaderH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self sectionHeader];
}
/** 配置头部视图 */
- (UIView *)sectionHeader{
    UIView *headerView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, kWindowW, sectionHeaderH)];
    headerView.backgroundColor = [UIColor whiteColor];
    NSArray *btnNames = @[@"切换校区",@"综合排序",@"筛选分类"];
    for (int i = 0; i < btnNames.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:JYGlobalBg forState:UIControlStateHighlighted];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [headerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWindowW/btnNames.count);
            make.left.mas_equalTo(i*kWindowW/btnNames.count);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    return headerView;
}

kRemoveCellSeparator

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JYProductDetailVC *vc = [[JYProductDetailVC alloc] init];
    vc.goodsID = [self.productInfoVM productIDForRow:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark *** Lazy Loading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_tableView registerClass:[JYClassifyCell class] forCellReuseIdentifier:cellIdentifier];
	}
	return _tableView;
}

- (JYProductInfoViewModel *)productInfoVM {
	if(_productInfoVM == nil) {
		_productInfoVM = [[JYProductInfoViewModel alloc] initWithType:_type sort:_sort];
	}
	return _productInfoVM;
}

@end
