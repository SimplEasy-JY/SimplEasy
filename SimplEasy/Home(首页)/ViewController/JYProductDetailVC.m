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
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 头部滚动详情图片视图 */
@property (nonatomic, strong) iCarousel *icView;
/** 分页控制器（小圆点） */
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation JYProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableViewHeader];
    //为头部滚动详情图片添加自动滚动定时器
    [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
        [self.icView scrollToItemAtIndex:self.icView.currentItemIndex+1 animated:YES];
    } repeats:YES];
    //注册cell
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
    return [@[@2,@3][section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//如果是第一个cell分区，那么只需要配置商品详情cell和商家信息cell
        if (indexPath.row == 0) {
            JYProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYProductDetailCell"];
            cell.placeLb.text = @"浙江农林大学东湖校区";
            return cell;
        }else if (indexPath.row == 1){
            JYSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSellerCell"];
            return cell;
        }
    }else{//如果是第二个分区，则配置评论cell
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"评论 %d",/** 评论的个数，从后台获取 */2];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"赞 %d",/** 赞的个数，从后台获取 */5];
            return cell;
        }else{
            JYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYCommentCell"];
            cell.commentLb.text = @"我最近正想买个洗脸仪呢，这个真的好用么？拉萨的克己复礼上看见对方；拉丝  阿斯顿立法局阿里斯顿肌肤    ；拉框的设计风；  啊； 刻录机；肥胖纹哦 if 会看到你发了";
            NSLog(@"cell.commentLb.height = %f",cell.commentLb.height);
            return cell;
        }
    }
    return nil;
    
}

#pragma mark *** <UITableViewDelegate> ***

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [@[@[@120,@120],@[@40,@120,@120]][indexPath.section][indexPath.row] floatValue];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消cell的选中状态
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

/** carousel的item下标改变后触发该方法 */
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    self.pageControl.currentPage = carousel.currentItemIndex;//设置小圆点的位置和当前carousel的item的位置一样
}

#pragma mark *** 懒加载 ***

- (iCarousel *)icView {
    if(_icView == nil) {
        _icView = [[iCarousel alloc] init];
        _icView.delegate = self;
        _icView.dataSource = self;
        _icView.pagingEnabled = YES;
        _icView.type = iCarouselTypeCoverFlow;
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
