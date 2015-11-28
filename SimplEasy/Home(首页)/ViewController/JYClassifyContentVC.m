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
/** 点击按钮后显示的表格视图 */
@property (nonatomic, strong) UITableView *choiceTableView;
/** 商品视图控制器 */
@property (nonatomic, strong) JYProductInfoViewModel *productInfoVM;
/** 排序（子分类）*/
@property (nonatomic, strong) NSString *sort;
/** choiceTV数据 */
@property (nonatomic, strong) NSArray *choiceArr;
/** 用于记录选中的btn */
@property (nonatomic, assign) NSInteger selectedBtn;
@end

@implementation JYClassifyContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sort = @"all";
    self.tableView.dataSource = self;
    [self choiceTableView];
    [self refreshTableView];
    self.choiceTableView.hidden = YES;
}

#pragma mark *** 似有方法 ***

/** 刷新界面 */
- (void)refreshTableView{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.productInfoVM refreshDataCompletionHandle:^(NSError *error) {
            if (error) {
                JYLog(@"刷新出错: %@",error.description);
                [self.tableView.header endRefreshing];
            }
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            [self nothingToShow];
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

/** 筛选分类刷新 */
- (void)changeSubClass{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.productInfoVM refreshDataCompletionHandle:^(NSError *error) {
        if (error) {
            JYLog(@"刷新出错: %@",error.description);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
        [self nothingToShow];
    }];
}

- (void)nothingToShow{
    if (!self.productInfoVM.rowNum>0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"这里还没有东西哦" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的嘛" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
        [btn setTitleColor:JYGlobalBg forState:UIControlStateSelected];
        btn.tag = (i+1)*1000;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        [headerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWindowW/btnNames.count);
            make.left.mas_equalTo(i*kWindowW/btnNames.count);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    UIButton *btn1 = (UIButton *)[headerView viewWithTag:1000];
    UIButton *btn2 = (UIButton *)[headerView viewWithTag:2000];
    UIButton *btn3 = (UIButton *)[headerView viewWithTag:3000];
    //加入点击事件
    [btn1 bk_addEventHandler:^(UIButton *sender) {
        JYLog(@"点击了按钮");
        self.selectedBtn = 0;
        self.choiceTableView.hidden = YES;
        sender.selected = !sender.selected;
        btn2.selected = NO;
        btn3.selected = NO;
        
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
    
    [btn2 bk_addEventHandler:^(UIButton *sender) {
        JYLog(@"点击了按钮2");
        self.selectedBtn = 1;
        self.choiceTableView.hidden = YES;
        sender.selected = !sender.selected;
        btn1.selected = NO;
        btn3.selected = NO;
        
        if (sender.selected) {
            //点击按钮的操作
            self.choiceTableView.hidden = NO;
            self.choiceArr = @[@"综合排序",@"最新上线",@"价格从高到低",@"价格从低到高"];
            [self.choiceTableView reloadData];
        }else{
            self.choiceTableView.hidden = YES;
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    [btn3 bk_addEventHandler:^(UIButton *sender) {
        JYLog(@"点击了按钮3");
        self.selectedBtn = 2;
        self.choiceTableView.hidden = YES;
        sender.selected = !sender.selected;
        btn1.selected = NO;
        btn2.selected = NO;
        
        if (sender.selected) {
            //点击按钮的操作
            self.choiceTableView.hidden = NO;
            self.choiceArr = self.model.subClass;
            [self.choiceTableView reloadData];
        }else{
            self.choiceTableView.hidden = YES;
            
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
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
        return sectionHeaderH;
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
        
        if (self.selectedBtn == 2) {
            self.sort = [self.choiceArr[indexPath.row] isEqualToString:@"全部"]?@"all":self.choiceArr[indexPath.row];
            self.productInfoVM = nil;
            self.choiceTableView.hidden = YES;
            [self changeSubClass];
        }else{
            self.choiceTableView.hidden = YES;
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

@end
