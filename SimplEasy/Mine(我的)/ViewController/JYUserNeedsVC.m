//
//  JYUserNeedsVC.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/14.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYUserNeedsVC.h"
#import "JYNeedsViewModel.h"
#import "JYUserInfoNetManager.h"
#import "JYNormalModel.h"
#import "JYNeedsCell.h"

@interface JYUserNeedsVC ()<UITableViewDelegate,UITableViewDataSource>

/** TableView */
@property (nonatomic, strong) UITableView *tableView;
/** 视图模型 */
@property (nonatomic, strong) JYNeedsViewModel *userNeedsVM;
/** 删除视图 */
@property (nonatomic, strong) UIView *deleteView;

@end

@implementation JYUserNeedsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMJRefresh];
    [JYFactory addBackItemToVC:self];
    self.view.backgroundColor = kRGBColor(236, 236, 236);
    UIBarButtonItem *deleteBBI = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(multiSelect:)];
    self.navigationItem.rightBarButtonItem = deleteBBI;
}


/** 进入多选模式 */
- (void)multiSelect: (UIBarButtonItem *)item{
    [self.tableView setEditing:!_tableView.editing animated:YES];
    [item setTitle:_tableView.editing?@"取消":@"编辑"];
    
    if (_tableView.editing) {
        [UIView animateWithDuration:0.3 animations:^{
            self.deleteView.frame = CGRectMake(0, kWindowH - 64 - 40, kWindowW, 30);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.deleteView.frame = CGRectMake(0, kWindowH, kWindowW, 30);
        }];
    }
}

/** 删除选中的需求 */
- (void)deleteSelectedNeeds: (UIButton *)sender {
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [self deleteNeedsAtIndexPath:indexPath];
    }
    [self multiSelect:self.navigationItem.rightBarButtonItem];
}

/** 根据indexPath删除 */
- (void)deleteNeedsAtIndexPath: (NSIndexPath *)indexPath {
    [JYUserInfoNetManager deleteNeedsWithNeedsID:[self.userNeedsVM needsIDForRow:indexPath.section].integerValue completionHandle:^(JYNormalModel *model, NSError *error) {
        if (model.status.integerValue == 1) {
            [self refreshData];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"删除失败，原因是:%@",model.errorMsg] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

/** 设置上下拉刷新 */
- (void)setMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.userNeedsVM getMoreDataCompletionHandle:^(NSError *error) {
            if (!error) {
                if ([self.userNeedsVM isLastPage]) {
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

/** 刷新数据 */
- (void)refreshData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.userNeedsVM refreshDataCompletionHandle:^(NSError *error) {
        if (!error) {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.userNeedsVM isLastPage]?[self.tableView.mj_footer endRefreshingWithNoMoreData]:[self.tableView.mj_footer resetNoMoreData];
        }else{
            JYLog(@"刷新出错： %@",error.description);
            [self.tableView.mj_header endRefreshing];
        }
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userNeedsVM.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYNeedsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYNeedsCell"];
    cell.urgent = [self.userNeedsVM isUrgentForRow:indexPath.row];
    cell.timeLb.text = [self.userNeedsVM timeForRow:indexPath.row];
    cell.needsLb.text = [self.userNeedsVM detailForRow:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.editing?nil:[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark *** TableView的编辑 ***

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /** 提示框 */
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除这个需求吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteNeedsAtIndexPath:indexPath];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark *** Lazy Loading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tintColor = JYGlobalBg;//多选打勾颜色
        _tableView.backgroundColor = kRGBColor(236, 236, 236);
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelectionDuringEditing = YES;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_tableView registerClass:[JYNeedsCell class] forCellReuseIdentifier:@"JYNeedsCell"];
	}
	return _tableView;
}

- (JYNeedsViewModel *)userNeedsVM {
	if(_userNeedsVM == nil) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:IMLoginUID];
        JYLog(@"userID = %@",userId);
        if (userId) {
            _userNeedsVM = [[JYNeedsViewModel alloc] initWithUserID:userId.integerValue];
        }
	}
	return _userNeedsVM;
}

- (UIView *)deleteView {
	if(_deleteView == nil) {
		_deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowH, kWindowW, 40)];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setTitle:@"删除所选需求" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn setBackgroundColor:JYGlobalBg];
        deleteBtn.frame = CGRectMake(5, 5, kWindowW-10, 30);
        [deleteBtn addTarget:self action:@selector(deleteSelectedNeeds:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteView addSubview:deleteBtn];
        [self.view addSubview:_deleteView];
	}
	return _deleteView;
}

@end
