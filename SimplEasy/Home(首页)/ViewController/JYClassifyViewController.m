//
//  JYClassifyViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassifyViewController.h"
#import "JYSellerCell.h"

@interface JYClassifyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *classArr;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JYHexColor(0x272C35);
    [self.view addSubview:self.tableView];
    _tableView.backgroundColor = JYHexColor(0x272C35);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, kWindowW*kAppDelegate.sideMenu.contentViewScaleValue/2-kAppDelegate.sideMenu.contentViewInPortraitOffsetCenterX+80));
    }];
    [self configHeaderView];
    [self configRightView];
}

- (void)configRightView{
    UIView *rightView = [[UIView alloc] init];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView.mas_right).mas_equalTo(0);
        make.bottom.top.mas_equalTo(self.view);
        make.width.mas_equalTo(80);
    }];
    rightView.backgroundColor = JYHexColor(0x272C35);
    
    /** 加入头部图像 */
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"typeiconHeader"]];
    iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.tableView.tableHeaderView.height);
    }];
    
    /** 加入签名图像 */
    UIImageView *signIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"typeiconsign"]];
    signIV.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:signIV];
    [signIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((kWindowH-self.tableView.tableHeaderView.height)/2);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    
    
}
- (void)configHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 120)];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.backgroundColor = JYHexColor(0x272C35);
//    [headerView addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.classArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textColor = [UIColor whiteColor];
    cell.selectedTextColor = JYGlobalBg;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.classArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"typeicon0%ld",indexPath.row+1]];
    cell.imageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"typeicon0%ld_selected",indexPath.row+1]];
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return (kWindowH-self.tableView.tableHeaderView.height)/self.classArr.count;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /** 回到contentView */
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark *** Lazy Loading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
	}
	return _tableView;
}

- (NSArray *)classArr {
	if(_classArr == nil) {
		_classArr = @[@"鞋服配饰",@"个人护理",@"生活用品",@"运动户外",@"旅行箱包",@"数码外设",@"图书音像",@"卡券转让",@"食品专区"];
	}
	return _classArr;
}

@end
