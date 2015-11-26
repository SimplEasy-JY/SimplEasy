//
//  JYClassifyViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassifyViewController.h"
#import "JYRootViewController.h"
#import "JYSellerCell.h"
#import "JYClassifyModel.h"
#import "JYClassifyContentVC.h"

#pragma mark *** 自定义cell ***



@interface JYClassifyTableViewCell : UITableViewCell

@end



@implementation JYClassifyTableViewCell


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
}

@end



#pragma mark *** 控制器 ***

static CGFloat rightViewWidth = 120;
static CGFloat headerViewHeight = 120;
/** 右边图标和签名离父视图的间隙 */
static CGFloat margin = 5;
/** 内容视图缩放后的宽度（竖屏） */
#define contentVCWidth (kWindowW * rootVC.sideMenu.contentViewScaleValue/2 - rootVC.sideMenu.contentViewInPortraitOffsetCenterX)


@interface JYClassifyViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 分类数组 */
@property (nonatomic, strong) NSArray *classArr;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 传回去的block */
@property (nonatomic, copy) ReturnBlock backBlock;

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
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, contentVCWidth + rightViewWidth));
    }];
    [self configHeaderView];
    [self configRightView];
}

- (void)didSelectTypeWithBlock:(ReturnBlock)block{
    self.backBlock = block;
}

/** 配置右侧的视图 */
- (void)configRightView{
    
    /** 右边的视图配置 */
    UIView *rightView = [[UIView alloc] init];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView.mas_right).mas_equalTo(0);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(rightViewWidth);
    }];
    rightView.backgroundColor = JYHexColor(0x272C35);
    
    /** 加入头部图像 */
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"typeiconHeader"]];
    iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(self.tableView.tableHeaderView.height);
    }];
    
    /** 加入签名图像 */
    UIImageView *signIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"typeiconsign"]];
    signIV.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:signIV];
    [signIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((kWindowH-self.tableView.tableHeaderView.height)/2);
        make.left.mas_equalTo(0);
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
    return self.classArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    JYClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[JYClassifyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    /** 颜色 */
    cell.textColor = [UIColor whiteColor];
    cell.selectedTextColor = JYGlobalBg;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = JYHexColor(0x272C35);
    
    /** 文字 */
    JYClassifyModel *model = self.classArr[indexPath.row];
    cell.textLabel.text = model.name;
    
    /** 图片 */
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.imageView.highlightedImage = [UIImage imageNamed:model.selectedIcon];
    
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JYClassifyContentVC *vc = [[JYClassifyContentVC alloc] init];
    JYClassifyModel *model = self.classArr[indexPath.row];
    vc.title = model.name;
    if (self.backBlock) {
        self.backBlock(vc,model.name);//实现block
    }
    /** 回到contentView */
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark *** Lazy Loading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
	}
	return _tableView;
}

- (NSArray *)classArr {
	if(_classArr == nil) {
		_classArr = [NSArray objectArrayWithFilename:@"Classify.plist"];
        NSMutableArray *mutableArr = [NSMutableArray new];
        for (NSDictionary *dict in _classArr) {
            JYClassifyModel *model = [JYClassifyModel new];
            [model setValuesForKeysWithDictionary:dict];
            [mutableArr addObject:model];
        }
        _classArr = [mutableArr copy];
	}
	return _classArr;
}

@end
