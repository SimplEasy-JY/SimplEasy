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
#import "JYProductDetailViewModel.h"
#import "UILabel+Line.h"
#import "UIImage+Circle.h"
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
/** 视图模型 */
@property (nonatomic, strong) JYProductDetailViewModel *pdVM;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JYProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    JYLog(@"\n\n******************** 进入详情页面 ********************\n\n");
    //获取数据
    [self.pdVM getDataFromNetCompleteHandle:^(NSError *error) {
        if (error) {
            JYLog(@"ERROR:%@",error.description);
        }
        JYLog(@"得到数据");
        [self configTableViewHeader];
        [self.tableView reloadData];
    }];
    
    //    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStyleDone handler:^(id sender) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }];
    //    self.navigationItem.leftBarButtonItem = leftBBI;
    
    //注册cell
    [self.tableView registerClass:[JYProductDetailCell class] forCellReuseIdentifier:@"JYProductDetailCell"];
    [self.tableView registerClass:[JYSellerCell class] forCellReuseIdentifier:@"JYSellerCell"];
    [self.tableView registerClass:[JYCommentCell class] forCellReuseIdentifier:@"JYCommentCell"];
}

#pragma mark *** 私有方法 ***

/** 配置tableView的头部视图 */
- (void)configTableViewHeader{
    [_timer invalidate];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 0, 320);
    
    /** 加入滚动视图 */
    [headerView addSubview: self.icView];
    [self.icView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headerView);
    }];
    
    /** 如果图片大于一张 */
    if ([self.pdVM picArrForProduct].count>1) {
        /** 加入pageControl */
        [headerView addSubview: self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(10);
        }];
        /** 为头部滚动详情图片添加自动滚动定时器 */
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
            [self.icView scrollToItemAtIndex:self.icView.currentItemIndex+1 animated:YES];
        } repeats:YES];
    }
    /** 如果没有图片，加入一个label，提示没有图片 */
    if ([self.pdVM picArrForProduct].count == 0) {
        UILabel *label = [[UILabel alloc] init];
        [headerView addSubview:label];
        label.text = @"没有图片哦";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.backgroundColor = JYHexColor(0x272C35);
}

/** 配置底部的按钮 */
- (void)configBottomButtons{
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(bottomBtnHeight);
    }];
    
    NSArray *btnNames = @[@"浏览",@"评论",@"收藏",@"联系卖家",@"立即易货"];
    NSArray *btnImages = @[[UIImage imageNamed:@"eye"],[UIImage imageNamed:@"bottomicon2_05"],[UIImage imageNamed:@"bottomicon2_03"]];
    NSArray *btnHighlightedImages = @[[UIImage imageNamed:@"eye"],[UIImage imageNamed:@"bottomicon2_05"],[UIImage imageNamed:@"bottomicon_03"]];
    NSArray *btnBgColors = @[kRGBColor(60, 183, 21),kRGBColor(55, 150, 84),kRGBColor(245, 245, 245)];
    
    for (int i = 0; i < btnImages.count; i++) {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [@[@2,@3][section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {/** 如果是第一个cell分区，那么只需要配置商品详情cell和商家信息cell */
        if (indexPath.row == 0) {
            /** 商品详情cell */
            JYProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYProductDetailCell"];
            cell.productDescLb.text = [self.pdVM descForProduct];//商品描述
            cell.currentPriceLb.text = [self.pdVM currentPriceForProduct];//当前价格
            cell.originPriceLb.text = [self.pdVM originPriceForProduct];//原始价格
            if (cell.originPriceLb.text) {
                [cell.originPriceLb addMidLine];//加入删除线
            }
            /** 需要先设置地点再设置时间，否则约束会乱，如果没有地点就不用设置 */
            cell.placeLb.text = self.schoolName;//学校名称
            cell.publishTimeLb.text = [self.pdVM publishTimeForProduct];//发布时间
            return cell;
        }
        /** 商家信息cell */
        JYSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSellerCell"];
        [cell.headIV sd_setImageWithURL:[self.pdVM headImageForSeller] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            image = [UIImage scaleToSize:image size:CGSizeMake(60, 60)];
            image = [UIImage circleImageWithImage:image borderWidth:0 borderColor:JYGlobalBg];
            cell.headIV.image = image;
        }];//设置头像
        cell.nickNameLb.text = [self.pdVM nameForSeller];// 设置昵称
        cell.schoolLb.text = self.schoolName;// 设置学校
        return cell;
    }
    /** 如果是第二个分区，则配置评论cell */
    else{
#warning 评论后台还没弄好，待完善
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
        cell.nickNameLb.text = @"评论人";
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
    return section == 0?0:20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消cell的选中状态
}

#pragma mark *** iCarouselDatasource & iCarouseDelegate ***

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [self.pdVM picArrForProduct].count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 320)];
        
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.clipsToBounds = YES;
        bgImageView.tag = 200;
        [view addSubview: bgImageView];
        
        /** 加入毛玻璃效果 */
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [view addSubview:blurView];
        [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 100;
        [view addSubview: imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
        
    }
    UIImageView *bgImageView = (UIImageView *)[view viewWithTag:200];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
    NSURL *url = [self.pdVM picArrForProduct][index];
    [bgImageView sd_setImageWithURL:url];
    [imageView sd_setImageWithURL:url];
    
    
    
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
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    /** 一旦用户拖动，停止计时器 */
    [self.timer invalidate];
}

#pragma mark *** 懒加载 ***

- (iCarousel *)icView {
    if(_icView == nil) {
        _icView = [[iCarousel alloc] init];
        _icView.delegate = self;
        _icView.dataSource = self;
        _icView.pagingEnabled = YES;
        _icView.type = iCarouselTypeLinear;
    }
    return _icView;
}

- (UIPageControl *)pageControl {
    if(_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.icView.numberOfItems;
        _pageControl.currentPage = self.icView.currentItemIndex;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:1];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return _pageControl;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, bottomBtnHeight, 0));
        }];
        [self configBottomButtons];
    }
    return _tableView;
}

- (JYProductDetailViewModel *)pdVM {
    if(_pdVM == nil) {
        _pdVM = [[JYProductDetailViewModel alloc] initWithID:[self.goodsID integerValue]];
    }
    return _pdVM;
}

@end
