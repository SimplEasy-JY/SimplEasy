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
#import "UIButton+VerticalBtn.h"

static NSString *cellIdentifier = @"Cell";
static CGFloat sectionHeaderH = 30.0;


@interface JYClassifyContentVC ()<UITableViewDelegate,UITableViewDataSource>

/** 表格视图 */
@property (nonatomic, strong) UITableView *tableView;
/** 点击按钮后显示的表格视图 */
@property (nonatomic, strong) UITableView *choiceTableView;
/** 商品视图控制器 */
@property (nonatomic, strong) JYProductInfoViewModel *productInfoVM;
/** 排序（子分类）*/
@property (nonatomic, strong) NSString *sort;
/** choiceTV数据 */
@property (nonatomic, strong) NSArray *choiceArr;

/** 切换校区按钮 */
@property (nonatomic, strong) UIButton *changeSchoolBtn;
/** 排序按钮 */
@property (nonatomic, strong) UIButton *sortBtn;
/** 筛选分类按钮 */
@property (nonatomic, strong) UIButton *subClassBtn;

/** 用于记录选中的btn */
@property (nonatomic, assign) NSInteger selectedBtn;
@end

@implementation JYClassifyContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    JYLog(@"\n\n******************** 进入分类内容界面 ********************\n\n");
    self.sort = @"all";
    [JYFactory addBackItemToVC:self];
    [self tableView];
    [self choiceTableView];
    [self setMJrefresh];
    self.choiceTableView.hidden = YES;
}

#pragma mark *** 私有方法 ***

/** 设置上下拉刷新 */
- (void)setMJrefresh{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.productInfoVM refreshDataCompletionHandle:^(NSError *error) {
            if (error) {
                JYLog(@"刷新出错: %@",error.description);
                [self.tableView.header endRefreshing];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.productInfoVM isLastPage]?[self.tableView.footer endRefreshingWithNoMoreData]:[self.tableView.footer resetNoMoreData];
        }];
    }];
    
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.productInfoVM getMoreDataCompletionHandle:^(NSError *error) {
            if (error) {
                JYLog(@"获取更多出错: %@",error.description);
                [self.tableView.footer endRefreshing];
            }
            if ([self.productInfoVM isLastPage]) {
                [self.tableView reloadData];
                [self.tableView.footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView reloadData];
                [self.tableView.footer resetNoMoreData];
                [self.tableView.footer endRefreshing];
            }
        }];
    }];
}

- (UIImage *)arrowImageIsRight: (BOOL)isRight{
    if (isRight) {
        UIImage *arrowRight = [UIImage imageNamed:@"arrow_right"];
        arrowRight = [arrowRight imResizedImage:CGSizeMake(6, 11) interpolationQuality:kCGInterpolationHigh];
        return arrowRight;
    }else{
        UIImage *arrowDown = [UIImage imageNamed:@"arrow_down"];
        arrowDown = [arrowDown imResizedImage:CGSizeMake(11, 6) interpolationQuality:kCGInterpolationHigh];
        return arrowDown;
    }
}
/** 数据的刷新 */
- (void)refreshData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.productInfoVM refreshDataCompletionHandle:^(NSError *error) {
        if (error) {
            JYLog(@"重新获取数据失败: %@",error.description);
        }
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        [self.productInfoVM isLastPage]?[self.tableView.footer endRefreshingWithNoMoreData]:[self.tableView.footer resetNoMoreData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/** 配置头部视图 */
- (UIView *)sectionHeader{
    UIView *headerView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, kWindowW, sectionHeaderH)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.changeSchoolBtn];
    [self.changeSchoolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWindowW/3);
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [headerView addSubview:self.sortBtn];
    [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWindowW/3);
        make.left.mas_equalTo(kWindowW/3);
        make.top.bottom.mas_equalTo(0);
    }];
    [headerView addSubview:self.subClassBtn];
    [self.subClassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWindowW/3);
        make.left.mas_equalTo(kWindowW/3*2);
        make.top.bottom.mas_equalTo(0);
    }];
    return headerView;
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.choiceTableView) {
        return self.choiceArr.count;
    }
    return [self.productInfoVM rowNum];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.choiceTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.highlightedTextColor = JYGlobalBg;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = self.choiceArr[indexPath.row];
        return cell;
    }
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
    if (tableView == self.choiceTableView) {
        return 40;
    }
    return 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.choiceTableView) {
        return 0;
    }
    return sectionHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.choiceTableView) {
        return nil;
    }
    return [self sectionHeader];
}

kRemoveCellSeparator

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.choiceTableView) {
        if (self.selectedBtn == 0) {
            self.choiceTableView.hidden = YES;
            self.changeSchoolBtn.selected = NO;
            [self.changeSchoolBtn setTitle:self.choiceArr[indexPath.row] forState:UIControlStateNormal];
        }else if (self.selectedBtn == 2) {
            self.sort = [self.choiceArr[indexPath.row] isEqualToString:@"全部"]?@"all":self.choiceArr[indexPath.row];
            [self.subClassBtn setTitle:self.choiceArr[indexPath.row] forState:UIControlStateNormal];
            self.productInfoVM = nil;
            self.choiceTableView.hidden = YES;
            self.subClassBtn.selected = NO;
            [self refreshData];//根据改变的子分类重新获取数据并刷新界面
        }else {
            self.choiceTableView.hidden = YES;
            [self.sortBtn setTitle:self.choiceArr[indexPath.row] forState:UIControlStateNormal];
            self.sortBtn.selected = NO;
        }
        return;
    }
    JYProductDetailVC *vc = [[JYProductDetailVC alloc] init];
    vc.goodsID = [self.productInfoVM productIDForRow:indexPath.row];
    vc.schoolName = [self.productInfoVM schoolNameForRow:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark *** Lazy Loading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
		_productInfoVM = [[JYProductInfoViewModel alloc] initWithType:_model.name sort:_sort];
	}
	return _productInfoVM;
}

- (UITableView *)choiceTableView {
	if(_choiceTableView == nil) {
		_choiceTableView = [[UITableView alloc] init];
        _choiceTableView.delegate = self;
        _choiceTableView.dataSource = self;
        _choiceTableView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        _choiceTableView.tableFooterView = [UIView new];
        [self.view addSubview:_choiceTableView];
        [_choiceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sectionHeaderH);
            make.left.right.bottom.mas_equalTo(0);
        }];
        [_choiceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ChoiceCell"];
	}
	return _choiceTableView;
}
/** 按钮们 */
- (UIButton *)changeSchoolBtn {
    if(_changeSchoolBtn == nil) {
        _changeSchoolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeSchoolBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _changeSchoolBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _changeSchoolBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_changeSchoolBtn setTitle:@"切换校区" forState:UIControlStateNormal];
        [_changeSchoolBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_changeSchoolBtn setTitleColor:JYGlobalBg forState:UIControlStateHighlighted];
        [_changeSchoolBtn setTitleColor:JYGlobalBg forState:UIControlStateSelected];
        [_changeSchoolBtn setImage:[self arrowImageIsRight:YES] forState:UIControlStateNormal];
        [_changeSchoolBtn setImage:[self arrowImageIsRight:NO] forState:UIControlStateSelected];
        _changeSchoolBtn.layer.borderWidth = 0.5;
        _changeSchoolBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //加入点击事件
        [_changeSchoolBtn bk_addEventHandler:^(UIButton *sender) {
            JYLog(@"点击了按钮");
            self.selectedBtn = 0;
            self.choiceTableView.hidden = YES;
            sender.selected = !sender.selected;
            _sortBtn.selected = NO;
            _subClassBtn.selected = NO;
            
            if (sender.selected) {
                //点击按钮的操作
                self.choiceTableView.hidden = NO;
#warning 大学数据待完善
                self.choiceArr = @[@"浙江大学",@"浙江农林大学",@"浙江传媒学院",@"浙江理工大学",@"浙江财经大学"];
                [self.choiceTableView reloadData];
            }else{
                self.choiceTableView.hidden = YES;
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeSchoolBtn;
}

- (UIButton *)sortBtn {
	if(_sortBtn == nil) {
		_sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sortBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _sortBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_sortBtn setTitle:@"综合排序" forState:UIControlStateNormal];
        [_sortBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_sortBtn setTitleColor:JYGlobalBg forState:UIControlStateHighlighted];
        [_sortBtn setTitleColor:JYGlobalBg forState:UIControlStateSelected];
        [_sortBtn setImage:[self arrowImageIsRight:YES] forState:UIControlStateNormal];
        [_sortBtn setImage:[self arrowImageIsRight:NO] forState:UIControlStateSelected];
        _sortBtn.layer.borderWidth = 0.5;
        _sortBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [_sortBtn bk_addEventHandler:^(UIButton *sender) {
            JYLog(@"点击了按钮2");
            self.selectedBtn = 1;
            self.choiceTableView.hidden = YES;
            sender.selected = !sender.selected;
            _changeSchoolBtn.selected = NO;
            _subClassBtn.selected = NO;
            
            if (sender.selected) {
                //点击按钮的操作
                self.choiceTableView.hidden = NO;
                self.choiceArr = @[@"综合排序",@"最新上线",@"价格从高到低",@"价格从低到高"];
                [self.choiceTableView reloadData];
            }else{
                self.choiceTableView.hidden = YES;
            }
        } forControlEvents:UIControlEventTouchUpInside];
	}
	return _sortBtn;
}

- (UIButton *)subClassBtn {
	if(_subClassBtn == nil) {
		_subClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _subClassBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _subClassBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _subClassBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_subClassBtn setTitle:@"筛选分类" forState:UIControlStateNormal];
        [_subClassBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_subClassBtn setTitleColor:JYGlobalBg forState:UIControlStateHighlighted];
        [_subClassBtn setTitleColor:JYGlobalBg forState:UIControlStateSelected];
        [_subClassBtn setImage:[self arrowImageIsRight:YES] forState:UIControlStateNormal];
        [_subClassBtn setImage:[self arrowImageIsRight:NO] forState:UIControlStateSelected];
        _subClassBtn.layer.borderWidth = 0.5;
        _subClassBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [_subClassBtn bk_addEventHandler:^(UIButton *sender) {
            JYLog(@"点击了按钮3");
            self.selectedBtn = 2;
            self.choiceTableView.hidden = YES;
            sender.selected = !sender.selected;
            _changeSchoolBtn.selected = NO;
            _sortBtn.selected = NO;
            
            if (sender.selected) {
                //点击按钮的操作
                self.choiceTableView.hidden = NO;
                self.choiceArr = self.model.subClass;
                [self.choiceTableView reloadData];
            }else{
                self.choiceTableView.hidden = YES;
                
            }
        } forControlEvents:UIControlEventTouchUpInside];
	}
	return _subClassBtn;
}



@end
