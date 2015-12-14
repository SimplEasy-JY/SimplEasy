//
//  JYFindController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYCircleViewController.h"
#import "JYNeedsViewModel.h"

@interface JYCircleViewController ()<UITableViewDataSource,UITableViewDelegate>

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** NeedsVM */
@property (nonatomic, strong) JYNeedsViewModel *needsVM;

@end

@implementation JYCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMJRefresh];
}

/** 设置上下拉刷新 */
- (void)setMJRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.needsVM refreshDataCompletionHandle:^(NSError *error) {
            if (!error) {
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.needsVM isLastPage]?[self.tableView.mj_footer endRefreshingWithNoMoreData]:[self.tableView.mj_footer resetNoMoreData];
            }else{
                JYLog(@"刷新出错： %@",error.description);
                [self.tableView.mj_header endRefreshing];
            }
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.needsVM getMoreDataCompletionHandle:^(NSError *error) {
            if (!error) {
                if ([self.needsVM isLastPage]) {
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer resetNoMoreData];
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                JYLog(@"%@",error.description);
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }];
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.needsVM.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.needsVM detailForRow:indexPath.row];
    cell.detailTextLabel.text = [self.needsVM userNameForRow:indexPath.row];
    cell.imageView.layer.cornerRadius = cell.contentView.height/2;
    cell.imageView.clipsToBounds = YES;
    [self.needsVM headImgForRow:indexPath.row]?[cell.imageView sd_setImageWithURL:[self.needsVM headImgForRow:indexPath.row]]:nil;
    return cell;
}


#pragma mark *** Lazy Loading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
	}
	return _tableView;
}

- (JYNeedsViewModel *)needsVM {
	if(_needsVM == nil) {
		_needsVM = [[JYNeedsViewModel alloc] initWithUserID:nil];
	}
	return _needsVM;
}

@end
