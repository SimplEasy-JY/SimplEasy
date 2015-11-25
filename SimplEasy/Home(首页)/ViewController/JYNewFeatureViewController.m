//
//  JYNewFeatureViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/7.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYNewFeatureViewController.h"
#import "JYLoginViewController.h"

@interface JYNewFeatureViewController ()<iCarouselDelegate,iCarouselDataSource>
/** iCarouselView */
@property (nonatomic, strong) iCarousel *icView;
/** 存放图片的数组 */
@property (nonatomic, strong) NSArray *imageArr;
/** 分页控制器（小圆点） */
@property (nonatomic, strong) UIPageControl *pageControl;
/** 定时器，如果用户不滑动，那么每三秒切换一次界面 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JYNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 将icView加入self.view */
    [self.view addSubview:self.icView];
    [_icView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    /** 将pageControl加入self.view */
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    /** 设置定时器 */
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
        [self.icView scrollToItemAtIndex:self.icView.currentItemIndex+1 animated:YES];
    } repeats:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;

}

#pragma mark *** iCarouselDataSource ***

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.imageArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 100;
        [view addSubview: imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
    }
    UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
    imageView.image = self.imageArr[index];
    /** 如果是最后一个界面，添加闪光区域 */
    if (index == self.imageArr.count-1) {
        FBShimmeringView *shineView = [FBShimmeringView new];
        [view addSubview:shineView];
        [shineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        shineView.contentView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        shineView.shimmering = YES;
    }
    return view;
}

#pragma mark *** iCarouselDelegate ***

/** carousel的item下标改变后触发该方法 */
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    self.pageControl.currentPage = carousel.currentItemIndex;//设置小圆点的位置和当前carousel的item的位置一样
    if (carousel.currentItemIndex == self.imageArr.count-1) {//如果滚到最后一个页面，则停止自动滚动
        [self.timer invalidate];
    }
}

/** 选中最后一个界面的操作 */
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if (index == self.imageArr.count-1) {
        /** 重新设置根视图，防止调用根视图的时候程序崩溃（加号） */
//        kAppDelegate.window.rootViewController = rootVC.sideMenu;
//        rootVC.sideMenu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController pushViewController:[[JYLoginViewController alloc]init] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** LazyLoading ***

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

- (NSArray *)imageArr {
	if(_imageArr == nil) {
		_imageArr = @[[UIImage imageNamed:@"welcome1"],[UIImage imageNamed:@"welcome2"],[UIImage imageNamed:@"welcome3"]];
	}
	return _imageArr;
}

- (UIPageControl *)pageControl {
	if(_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.icView.numberOfItems;
        _pageControl.currentPage = self.icView.currentItemIndex;
        _pageControl.currentPageIndicatorTintColor = JYGlobalBg;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
	}
	return _pageControl;
}

@end
