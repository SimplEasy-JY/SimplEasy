//
//  JYClassifyViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassifyViewController.h"
#import "JYSellerCell.h"
#import "JYClassifyModel.h"

static CGFloat rightViewWidth = 80;
static CGFloat headerViewHeight = 120;
static CGFloat statusBarHeight = 20;
/** 右边图标和签名离父视图的间隙 */
static CGFloat margin = 5;
/** 内容视图缩放后的宽度（竖屏） */
#define contentVCWidth (kWindowW * kAppDelegate.sideMenu.contentViewScaleValue/2 - kAppDelegate.sideMenu.contentViewInPortraitOffsetCenterX)

@interface JYClassifyViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 分类数组 */
@property (nonatomic, strong) NSArray *classArr;
/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = JYHexColor(0x272C35);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(statusBarHeight, 0, 0, contentVCWidth + rightViewWidth));
    }];
    [self configHeaderView];
    [self configRightView];
}

/** 配置右侧的视图 */
- (void)configRightView{
    /** 右边的视图配置 */
    UIView *rightView = [[UIView alloc] init];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView.mas_right).mas_equalTo(0);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(statusBarHeight);
        make.width.mas_equalTo(rightViewWidth);
    }];
    rightView.backgroundColor = JYHexColor(0x272C35);
    
    /** 加入头部图像 */
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"typeiconHeader"]];
    iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(self.tableView.tableHeaderView.height);
    }];
    
    /** 加入签名图像 */
    UIImageView *signIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"typeiconsign"]];
    signIV.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:signIV];
    [signIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((kWindowH-self.tableView.tableHeaderView.height)/2);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.bottom.mas_equalTo(-20);
    }];
    
    
}

/** 配置头部视图 */
- (void)configHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, headerViewHeight)];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    /** 颜色 */
    cell.textColor = [UIColor whiteColor];
    cell.selectedTextColor = JYGlobalBg;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = JYHexColor(0x272C35);
    
    /** 文字 */
    JYClassifyModel *model = self.dataArr[indexPath.row];
    if (model.subClass) {
        cell.textLabel.text = model.name;
    }else{
        cell.textLabel.text = [NSString stringWithFormat: @"    %@",model.name];
    }
    /** 图片 */
    if (model.icon && model.selectedIcon) {
        cell.imageView.image = [UIImage imageNamed:model.icon];
        cell.imageView.highlightedImage = [UIImage imageNamed:model.selectedIcon];
    }else{
        cell.imageView.image = nil;
        cell.imageView.highlightedImage = nil;
    }
    
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JYClassifyModel *model = self.dataArr[indexPath.row];
    if (model.subClass && !model.isSelected) {
        /** 将subClass中的子类型模型化，加入到data数组中 */
        NSMutableArray *mutArr = [NSMutableArray new];
        for (NSString *str in model.subClass) {
            JYClassifyModel *model = [JYClassifyModel new];
            model.name = str;
            model.icon = nil;
            model.selectedIcon = nil;
            model.subClass = nil;
            model.selected = nil;
            [mutArr addObject:model];
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, model.subClass.count)];
        [self.dataArr insertObjects:[mutArr copy] atIndexes:indexSet];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        model.selected = YES;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }else if(model.subClass && model.isSelected){/** 从data数组中删除子类 */
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, model.subClass.count)];
        [self.dataArr removeObjectsAtIndexes:indexSet];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        model.selected = NO;
    }else{
        /** 回到contentView */
        [self.sideMenuViewController hideMenuViewController];
    }
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
		_classArr = [NSArray objectArrayWithFilename:@"Classify.plist"];
	}
	return _classArr;
}

- (NSMutableArray *)dataArr {
	if(_dataArr == nil) {
        _dataArr = [NSMutableArray new];
        for (NSDictionary *dict in self.classArr) {
            JYClassifyModel *model = [JYClassifyModel new];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArr addObject:model];
        }
	}
	return _dataArr;
}

@end
