//
//  JYFindController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYCircleViewController.h"

@interface JYCircleViewController ()<UITableViewDataSource,UITableViewDelegate>

/** tableView */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
	}
	return _tableView;
}

@end
