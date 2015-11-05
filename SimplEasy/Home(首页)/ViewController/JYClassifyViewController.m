//
//  JYClassifyViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassifyViewController.h"

@interface JYClassifyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *classArr;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
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
    cell.textLabel.text = self.classArr[indexPath.row];
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
		_classArr = @[@"鞋服配饰",@"文具娱乐",@"生活用品",@"个人护理",@"体育用品",@"代步工具"];
	}
	return _classArr;
}

@end
