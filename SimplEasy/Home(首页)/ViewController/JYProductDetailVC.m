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
#import "UIButton+VerticalBtn.h"

static CGFloat bottomBtnWidth = 40;
static CGFloat bottomBtnHeight = 50;

@interface JYProductDetailVC ()<UITableViewDelegate,UITableViewDataSource,iCarouselDelegate,iCarouselDataSource>
/** tableView */
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView;
/** 头部滚动详情图片视图 */
@property (nonatomic, strong) iCarousel *icView;
/** 分页控制器（小圆点） */
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation JYProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configTableViewHeader];
    [self configBottomButtons];
    //为头部滚动详情图片添加自动滚动定时器
    [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
        [self.icView scrollToItemAtIndex:self.icView.currentItemIndex+1 animated:YES];
    } repeats:YES];
    //注册cell
    [self.tableView registerClass:[JYProductDetailCell class] forCellReuseIdentifier:@"JYProductDetailCell"];
    [self.tableView registerClass:[JYSellerCell class] forCellReuseIdentifier:@"JYSellerCell"];
    [self.tableView registerClass:[JYCommentCell class] forCellReuseIdentifier:@"JYCommentCell"];
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

/** 配置底部的按钮 */
- (void)configBottomButtons{
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(bottomBtnHeight);
    }];
    NSArray *btnNames = @[@"收藏",@"评论",@"赞",@"联系卖家",@"立即易货"];
    NSArray *btnImages = @[[UIImage imageNamed:@"bottomicon2_03"],[UIImage imageNamed:@"bottomicon2_05"],[UIImage imageNamed:@"bottomicon2_07"]];
    NSArray *btnHighlightedImages = @[[UIImage imageNamed:@"bottomicon_03"],[UIImage imageNamed:@"bottomicon2_05"],[UIImage imageNamed:@"bottomicon_07"]];
    NSArray *btnBgColors = @[kRGBColor(60, 183, 21),kRGBColor(55, 150, 84),kRGBColor(245, 245, 245)];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:btn];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setImage:btnImages[i] forState:UIControlStateNormal];
        [btn setImage:btnHighlightedImages[i] forState:UIControlStateHighlighted];
        [btn setBackgroundColor:btnBgColors[2]];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*bottomBtnWidth);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(bottomBtnWidth);
        }];
        [btn centerImageAndTitleWithSpace:3.0f];
    }
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:btn];
        [btn setTitle:btnNames[3+i] forState:UIControlStateNormal];
        btn.titleLabel.textColor = [UIColor darkGrayColor];
        [btn setBackgroundColor:btnBgColors[i]];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((kWindowW-3*bottomBtnWidth)/2);
            make.left.mas_equalTo(3*bottomBtnWidth+i*(kWindowW-3*bottomBtnWidth)/2);
            make.top.bottom.mas_equalTo(0);
        }];
    }
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [@[@2,@3][section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {/** 如果是第一个cell分区，那么只需要配置商品详情cell和商家信息cell */
        if (indexPath.row == 0) {
        /** 商品详情cell */
            JYProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYProductDetailCell"];
            cell.productDescLb.text = @"［附专柜小票］洗脸仪  乐天免税店买 5月12号韩国买的，只用过一次。［附专柜小票］洗脸仪  乐天免税店买 5月12号韩国买的，只用过一次。［附专柜小票］洗脸仪  乐天免税店买 5月12号韩国买的，只用过一次。［附专柜小票］洗脸仪  乐天免税店买 5月12号韩国买的，只用过一次。［附专柜小票］洗脸仪  乐天免税店买 5月12号韩国买的，只用过一次。";
            cell.currentPriceLb.text = @"¥ 35";
            cell.originPriceLb.text = @"¥ 45";
            /** 需要先设置地点再设置时间，否则约束会乱，如果没有地点就不用设置 */
            cell.placeLb.text = @"浙江农林大学东湖校区";
            cell.publishTimeLb.text = @"5分钟前";
            return cell;
        }
    /** 商家信息cell */
        JYSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSellerCell"];
        cell.headIV.image = [UIImage imageNamed:@"picture_11"];
        cell.nickNameLb.text = @"我是大蕴蕴";
        cell.schoolLb.text = @"浙江农林大学";
        cell.rankIV.image = [UIImage imageNamed:@"picture_30"];
        return cell;
    }else{/** 如果是第二个分区，则配置评论cell */
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"评论 %d",/** 评论的个数，从后台获取 */2];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"赞 %d",/** 赞的个数，从后台获取 */5];
            return cell;
        }
        JYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYCommentCell"];
        cell.headIV.image = [UIImage imageNamed:@"picture_46"];
        cell.nickNameLb.text = @"乔昔之";
        cell.timeLb.text = @"11-5 13:28";
        cell.rankIV.image = [UIImage imageNamed:@"picture_38"];
        cell.commentLb.text = @"我最近正想买个洗脸仪呢，这个真的好用么？味全丹麦活性菌，源自丹麦©SINCE1916.";
        return cell;
    }
}

#pragma mark *** <UITableViewDelegate> ***

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
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

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, bottomBtnHeight, 0));
        }];
	}
	return _tableView;
}

@end
