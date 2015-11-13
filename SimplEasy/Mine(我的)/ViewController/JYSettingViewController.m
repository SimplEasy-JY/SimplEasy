//
//  JYSettingViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/13.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYSettingViewController.h"

@interface JYSettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self configBottomBtn];
    // Do any additional setup after loading the view.
}

- (void)configBottomBtn{
    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOutBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [self.view addSubview:logOutBtn];
    [logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logOutBtn setBackgroundColor:JYGlobalBg];
    [logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [@[@1,@3,@3][section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @[@[@"切换学校"],@[@"通知",@"隐私与安全",@"通用设置"],@[@"清理缓存",@"意见反馈",@"关于简易"]][indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = @"浙江传媒大学";
        cell.detailTextLabel.textColor = kRGBColor(109, 194, 241);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.textLabel.mas_centerY);
            make.left.mas_equalTo(cell.textLabel.mas_right).mas_equalTo(10);
        }];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"10M";
        }else if(indexPath.row == 2){
            cell.detailTextLabel.text = @"New";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.layer.cornerRadius = 7.5;
            cell.detailTextLabel.textColor = JYGlobalBg;
            cell.detailTextLabel.backgroundColor = JYGlobalBg;
            [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.textLabel.mas_centerY);
                make.left.mas_equalTo(cell.textLabel.mas_right).mas_equalTo(10);
                make.height.mas_equalTo(15);
            }];
        }
    }
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

kRemoveCellSeparator
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
	}
	return _tableView;
}

@end
