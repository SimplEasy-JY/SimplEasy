//
//  JYClassifyContentVC.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/21.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassifyContentVC.h"
#import "JYClassifyCell.h"

static NSString *cellIdentifier = @"Cell";
static CGFloat sectionHeaderH = 30.0;

@interface JYClassifyContentVC ()<UITableViewDelegate,UITableViewDataSource>

/** 表格视图 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYClassifyContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
}


#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.productIV.image = [UIImage imageNamed:@"picture_12"];
    cell.productDesc.text = @"啊就是浪费空间啊浪费就发牢骚的风景是否啦";
    cell.currentPrice.text = @"¥ 35";
    cell.originPrice.text = @"¥ 48";
    cell.schoolNameLb.text = @"浙江农林大学";
    cell.publishDateLb.text = @"11-30";
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
    JYLog(@"配置了没");
//    return section == 0?[self sectionHeader]:nil;
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

@end
