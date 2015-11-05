//
//  JYProductDetailVC.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductDetailVC.h"
#import "JYProductDetailCell.h"
#import "JYSellerCell.h"
#import "JYCommentCell.h"

@interface JYProductDetailVC ()<UITableViewDelegate,UITableViewDataSource,iCarouselDelegate,iCarouselDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) iCarousel *icView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation JYProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableViewHeader];
    [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
        [self.icView scrollToItemAtIndex:self.icView.currentItemIndex+1 animated:YES];
    } repeats:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"JYProductDetailCell" bundle:nil] forCellReuseIdentifier:@"JYProductDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JYSellerCell" bundle:nil] forCellReuseIdentifier:@"JYSellerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JYCommentCell" bundle:nil] forCellReuseIdentifier:@"JYCommentCell"];
}

#pragma mark *** 私有方法 ***

/** 配置tableView的头部视图 */
- (void)configTableViewHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 320)];
    //加入滚动视图
    [headerView addSubview: self.icView];
    [self.icView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headerView);
    }];
    //加入pageControl
    [headerView addSubview: self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(10);
        
    }];
    self.tableView.tableHeaderView = headerView;
    
    
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JYProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYProductDetailCell"];
            return cell;
        }else if (indexPath.row == 1){
            JYSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSellerCell"];
            return cell;
        }
    }else{
        JYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYCommentCell"];
        return cell;
    }
    return nil;
    
}
#pragma mark *** <UITableViewDelegate> ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark *** iCarouselDatasource & iCarouseDelegate ***

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 320)];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 100;
        [view addSubview: imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
    }
    UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
    imageView.image = @[[UIImage imageNamed:@"picture_15"],[UIImage imageNamed:@"picture_17"],[UIImage imageNamed:@"picture_19"]][index];
    return view;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    self.pageControl.currentPage = carousel.currentItemIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** 懒加载 ***
- (iCarousel *)icView {
	if(_icView == nil) {
		_icView = [[iCarousel alloc] init];
        _icView.delegate = self;
        _icView.dataSource = self;
        _icView.pagingEnabled = YES;
        _icView.type = iCarouselTypeCoverFlow;
//        _icView.autoscroll = 0.4;
        
	}
	return _icView;
}

- (UIPageControl *)pageControl {
	if(_pageControl == nil) {
		_pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.icView.numberOfItems;
        _pageControl.currentPage = self.icView.currentItemIndex;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
	}
	return _pageControl;
}

@end
