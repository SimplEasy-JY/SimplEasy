//
//  JYFindController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYCircleViewController.h"
#import "JYNeedsViewModel.h"
#import "JYNeedsCell.h"

@interface JYCircleViewController ()<UITableViewDataSource,UITableViewDelegate>

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** NeedsVM */
@property (nonatomic, strong) JYNeedsViewModel *needsVM;

@end

@implementation JYCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = @"需求圈";
    [self setMJRefresh];
}

/** 设置上下拉刷新 */
- (void)setMJRefresh {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.needsVM.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYNeedsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYNeedsCell"];
    cell.urgent = [self.needsVM isUrgentForRow:indexPath.row];
    [cell.headImg sd_setImageWithPreviousCachedImageWithURL:[self.needsVM headImgForRow:indexPath.row] andPlaceholderImage:[UIImage imageNamed:@"IM_head_maile"] options:SDWebImageAvoidAutoSetImage progress:nil completed:nil];
    BOOL isSameTime = indexPath.row >= 1?[[self.needsVM timeForRow:indexPath.row] isEqualToString:[self.needsVM timeForRow:indexPath.row-1]]:false;
    cell.timeLb.text = isSameTime?nil:[self.needsVM timeForRow:indexPath.row];
    cell.needsLb.text = [self.needsVM detailForRow:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.editing?nil:[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark *** Lazy Loading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kRGBColor(236, 236, 236);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_tableView registerClass:[JYNeedsCell class] forCellReuseIdentifier:@"JYNeedsCell"];
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
