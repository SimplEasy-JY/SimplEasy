//
//  ViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYHomeController.h"
#import "UIBarButtonItem+Extension.h"
#import "JYProductDetailVC.h"
#import "JYWebViewController.h"
#import "JYClassifyViewController.h"
#import "JYClassifyContentVC.h"
#import "JYClassifyModel.h"

#import "JYLoopViewModel.h"
#import "JYGoodsViewModel.h"

#import "JYHomeProductCell.h"
#import "JYRecommendCell.h"
#import "JYFreeChargeCell.h"
#import "JYClassifyCell.h"

//category
#import "UIImage+Circle.h"
#import "UIButton+VerticalBtn.h"

#import "JYLoginViewController.h"
/**  cell id */
static NSString *JYLoopCellIndentifier = @"loopCell";
static NSString *JYLoopCellSecondIndentifier = @"loopSecondCell";
static NSString *JYLoopCellThirdIndentifier = @"loopThirdCell";
static NSString *JYHomeProductCellIndentifier = @"JYHomeProductCell";
static NSString *JYRecommendCellIndentifier = @"JYRecommendCell";
static NSString *JYChargeCellIndentifier = @"freeChargeCell";

@interface JYHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,iCarouselDelegate,iCarouselDataSource>{
    /**  page */
    int _page;
    /**  type */
    int _cellType;
    /**  当前button */
    UIButton *_currentButton;
    /**  今日上新array */
    NSArray *_firstGoodsArray;
    /**  精选array */
    NSArray *_secondGoodsArray;
    /**  免费array */
    NSArray *_thirdGoodsArray;
    /**  当前count */
    NSInteger _currentCount;
    
}

/**  tableview */
@property(strong,nonatomic)UITableView *tableView;
/**  searchDisPlay */
@property(strong,nonatomic)UISearchController *searchController;
/**  vm */
@property(strong,nonatomic)JYLoopViewModel *loopVM;
@property(strong,nonatomic)JYGoodsViewModel *goodsVM;

/**  cell reload array */
@property(strong,nonatomic)NSMutableArray *reloadArray;

/**  顶部轮播 */
@property(strong,nonatomic)iCarousel *firstLoopView;
@property(strong,nonatomic)UIPageControl *firstLoopPage;
@property(strong,nonatomic)iCarousel *secondLoopView;
@property(strong,nonatomic)iCarousel *thirdLoopView ;
/**  segmented Control */
@property(strong,nonatomic)NSArray *segmentItemsArray;

@property(strong,nonatomic)NSArray *goodsTitleArray;
@end

@implementation JYHomeController
#pragma mark -枚举
typedef NS_ENUM(NSInteger, loopType) {
    //以下是枚举成员
    firstLoop = 1,
    secondLoop = 2,
};
typedef NS_ENUM(NSInteger, cellType) {
    //以下是枚举成员
    homeProduct = 0,
    recommend = 1,
    freeCharge = 2,
};
#pragma mark -懒加载
/**  searchController */
-(UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController  alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(0, 0, kWindowW-130, 28);
    }
    return _searchController;
}
/**  tablView */
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView  alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tableView;
}
-(NSMutableArray *)reloadArray{
    if (!_reloadArray) {
        self.reloadArray = [[NSMutableArray  alloc]init];
    }
    return _reloadArray;
}


-(NSArray *)goodsTitleArray{
    if (!_goodsTitleArray) {
        self.goodsTitleArray = [[NSArray  alloc]initWithObjects:@"all",@"hot",@"free",nil];
    }
    return _goodsTitleArray;
}
-(NSArray *)segmentItemsArray{
    if (!_segmentItemsArray) {
        self.segmentItemsArray = [[NSArray  alloc]initWithObjects:@"今日上新",@"精选推荐",@"免费易货",nil];
    }
    return _segmentItemsArray;
}

-(iCarousel *)firstLoopView{
    if (!_firstLoopView) {
        self.firstLoopView = [[iCarousel  alloc]init];
        //就是仿写的CollectionView
        _firstLoopView.delegate = self;
        _firstLoopView.dataSource = self;
        //修改3D显示模式
        _firstLoopView.type = iCarouselTypeLinear;
        //自动展示,0表示不滚动，越大滚动越快
        _firstLoopView.autoscroll = 0;
        //水平还是垂直  no水平
        _firstLoopView.vertical = NO;
        //改为翻页模式
        _firstLoopView.pagingEnabled = YES;
        
    }
    return _firstLoopView;
}

-(UIPageControl *)firstLoopPage{
    if (!_firstLoopPage) {
        self.firstLoopPage = [[UIPageControl  alloc]init];
        _firstLoopPage.numberOfPages = self.firstLoopView.numberOfItems;
        _firstLoopPage.currentPage = self.firstLoopView.currentItemIndex;
        _firstLoopPage.currentPageIndicatorTintColor = [UIColor whiteColor];
        _firstLoopPage.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _firstLoopPage;
    
}

-(iCarousel *)secondLoopView{
    if (!_secondLoopView) {
        self.secondLoopView = [[iCarousel  alloc]init];
        _secondLoopView.delegate = self;
        _secondLoopView.dataSource = self;
        
        //修改3D显示模式
        _secondLoopView.type = iCarouselTypeLinear;
        //自动展示,0表示不滚动，越大滚动越快
        _secondLoopView.autoscroll = 0;
        //水平还是垂直  no水平
        _secondLoopView.vertical = NO;

        //改为翻页模式
        _secondLoopView.pagingEnabled = YES;
    }
    return _secondLoopView;
    
}
-(iCarousel *)thirdLoopView{
    if (!_thirdLoopView) {
        self.thirdLoopView = [[iCarousel  alloc]init];
        _thirdLoopView.delegate = self;
        _thirdLoopView.dataSource = self;
        //修改3D显示模式
        _thirdLoopView.type = iCarouselTypeLinear;
        //自动展示,0表示不滚动，越大滚动越快
        _thirdLoopView.autoscroll = 0;
        //水平还是垂直  no水平
        _thirdLoopView.vertical = NO;
        _thirdLoopView.currentItemIndex = 0;
        
        //改为翻页模式
        _thirdLoopView.pagingEnabled = YES;
    }
    return _thirdLoopView;
    
}

-(JYLoopViewModel *)loopVM{
    if (!_loopVM) {
        _loopVM = [JYLoopViewModel new];
    }
    return _loopVM;
}
-(JYGoodsViewModel *)goodsVM{
    if (!_goodsVM) {
        self.goodsVM = [[JYGoodsViewModel  alloc]init];
    }
    return _goodsVM;
    
}

//通知方法
-(void)login{
    //刷新
    [self.tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNav];
    [self setupTableView];
    
    
    /**  轮播定时滚动 */
    [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
        [self.firstLoopView scrollToItemAtIndex:self.firstLoopView.currentItemIndex+1 animated:YES];
    } repeats:YES];
    [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
        [self.secondLoopView scrollToItemAtIndex:self.secondLoopView.currentItemIndex+1 animated:YES];
    } repeats:YES];
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"JYHomeProductCell" bundle:nil] forCellReuseIdentifier:JYHomeProductCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"JYRecommendCell" bundle:nil] forCellReuseIdentifier:JYRecommendCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"JYFreeChargeCell" bundle:nil] forCellReuseIdentifier:JYChargeCellIndentifier];
    
    //监听登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:IMLoginNotification object:nil];
}



-(void)setNav{
    
    //中间的搜索条
    CGRect frame = CGRectMake(0, 0, kWindowW-130, 28);
    /**  加中间层，防止切换闪 */
    UIView *titleView = [[UIView alloc] initWithFrame:frame];

    //设置边框宽度和颜色   取消黑线
    [titleView.layer setBorderWidth:1];
    [titleView.layer setBorderColor:[UIColor whiteColor].CGColor];
    titleView.layer.masksToBounds = YES;
//    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:frame];

    /**  设置自定义搜索图片 */
    
    [self.searchController.searchBar setImage:[UIImage imageNamed:@"topicon_3"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //设置背景颜色
    UIView *searchTextField = nil;
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    searchTextField = [[[self.searchController.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = kRGBColor(240, 240, 240);

#warning 后台数据替换
    self.searchController.searchBar.placeholder = @"简易破蛋日大酬宾~";
    [titleView addSubview:self.searchController.searchBar];
    self.navigationItem.titleView = titleView;

    
    
    //分类按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40,40);
    [leftButton setTitle:@"分类" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(28, -46, 0, 0)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [leftButton setImage:[UIImage imageNamed:@"topicon_1"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(-8, -8, 0, 0)];
    /**  分类按钮响应方法 */
    [leftButton bk_addEventHandler:^(UIButton *sender) {
        JYClassifyViewController *classifyVC = (JYClassifyViewController *)self.sideMenuViewController.leftMenuViewController;
        [classifyVC didSelectTypeWithBlock:^(JYClassifyContentVC *viewController, JYClassifyModel *model) {
            viewController.title = model.name;
            viewController.model = model;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }];
        
        [self.sideMenuViewController presentLeftMenuViewController];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //定位按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40,40);
    [rightButton setTitle:@"定位" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(28, -15, 0, 0)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [rightButton setImage:[UIImage imageNamed:@"topicon_2"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(-8, 15, 0, 0)];
    [rightButton bk_addEventHandler:^(id sender) {
        JYLog(@"按了定位按钮");
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}

-(void)setupTableView{
    self.loopVM.type = firstLoop;
    [self.loopVM refreshDataCompletionHandle:^(NSError *error) {
        [self.firstLoopView reloadData];
        YSHLog(@"获取数据");
        self.loopVM.type = secondLoop;
        [self.loopVM refreshDataCompletionHandle:^(NSError *error) {
            [self.thirdLoopView reloadData];
        }];
    }];
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self isRefresh:YES];
    }];
    [self.tableView.mj_header beginRefreshing];
    //添加上拉加载
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self isRefresh:NO];
    }];
}
#pragma mark *** iCarouselDatasource & iCarouseDelegate ***

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    if (carousel == _firstLoopView) {
        return self.loopVM.loopImageUrlArray.count;
    } else if (carousel == _secondLoopView){
        return 3;
    }
    return self.loopVM.loopImageUrlArray.count;
    
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (carousel == self.firstLoopView){
        if (!view) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, firstLVH)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, firstLVH)];
            imageView.tag = 100;
            [view addSubview: imageView];
        }
        UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.loopVM.loopImageUrlArray[index]] placeholderImage:nil];
        return view;
    }else if (carousel == self.secondLoopView){
        if (!view) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, firstLVH, kWindowW, secondLVH)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kWindowW-30, 30)];
            imageView.tag = 1;
            label.tag = 101;
            [view addSubview:imageView];
            [view addSubview:label];
        }
        UIImageView *imageView = (UIImageView *)[view viewWithTag:1];
        imageView.image = [UIImage imageNamed:@"middleicon_15"];
        UILabel *label = (UILabel *)[view viewWithTag:101];
        label.text =  @"【急需】求购二手小电驴，价格1500左右 ";
        label.font = [UIFont systemFontOfSize:13];
        return  view;
    }else if (carousel == self.thirdLoopView) {
        if (!view) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (kWindowW-20)/2, 100)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (kWindowW-20)/2, 100 )];
            imageView.tag = 10;
            imageView.backgroundColor = [UIColor yellowColor];
            [view addSubview:imageView];
        }
        UIImageView *imageView = (UIImageView *)[view viewWithTag:10];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.loopVM.loopImageUrlArray[index]] placeholderImage:nil];
        return  view;

    }
    return nil;
}

/**  添加循环滚动 */
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    if (carousel == _thirdLoopView) {
        if (option == iCarouselOptionSpacing)
        {
            return value * 1.066 ;
        }
    }
    
    if (option == iCarouselOptionCount) {
        return YES;
    }
    return value;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    if (carousel == _firstLoopView) {
         self.firstLoopPage.currentPage = carousel.currentItemIndex;
    }
   
}
/**  选中方法 */
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"选择了第%ld张",index);
    if (carousel == _firstLoopView) {
        JYWebViewController *JYWebVC = [[JYWebViewController alloc]init];
        NSString *webUrl = [NSString stringWithFormat:@"http://%@",self.loopVM.loopWebUrlArray[index]];
        JYWebVC.webUrl = webUrl;
        JYWebVC.hidesBottomBarWhenPushed = YES;
        JYWebVC.title = @"这里是自定义标题";
        [self.navigationController pushViewController:JYWebVC animated:YES];
    }

}

#pragma mark - searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    JYLog(@"点击了搜索");

}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    JYLog(@"搜索");
    return YES;
}
kRemoveCellSeparator

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section == 2) {
            return 0;
        }
        return 10;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    }
    else {
        return 3;
    }
}

/**  cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
#warning test
    if (self.searchController.active) {
        return 10;
    }
    if (section == 0) {
        return 2;
    }
    else if(section == 1) {
        return 1;
    } else {
        if (_cellType == 2) {
            //如果是奇数，少一个数据，
            return (self.goodsVM.dataArr.count / 2 );
            
        }
        return self.goodsVM.dataArr.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (indexPath.row == 0 ? 116:30);
    }
    return UITableViewAutomaticDimension;

}
/**  首次加载cell的高度， 提高性能 */
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
/**  header */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section == 2) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 30)];
            /**  设置边框宽度和颜色 */
            [[bgView layer]setBorderWidth:0.5];
            [[bgView layer]setBorderColor:kRGBColor(217, 217, 217).CGColor];
            for (int i=0; i<self.segmentItemsArray.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                /**  设置button的参数 */
                [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:JYHexColor(0x272C35) cornerRadius:0] forState:UIControlStateSelected];
                button.tag = i;
                button.titleLabel.font = [UIFont systemFontOfSize:13];
                [button setTitle:self.segmentItemsArray[i] forState:UIControlStateNormal];
                [button setTitleColor:kRGBColor(54, 54, 54) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                button.frame = CGRectMake(0+kWindowW/self.segmentItemsArray.count*i, 0, kWindowW/self.segmentItemsArray.count, 30);
                if (i == 1) {
                    //                [[button layer]setBorderWidth:1];
                    //                [[button layer]setBorderColor:kRGBColor(217, 217, 217).CGColor];
                    float height = button.frame.size.height;
                    float width = button.frame.size.width-0.5;
                    CALayer *leftBorder = [CALayer layer];
                    CALayer *rightBorder = [CALayer layer];
                    leftBorder.frame = CGRectMake(0, 0, 0.5,height );
                    leftBorder.backgroundColor = kRGBColor(217, 217, 217).CGColor;
                    [button.layer addSublayer:leftBorder];
                    rightBorder.frame = CGRectMake(width, 0, 0.5, height);
                    rightBorder.backgroundColor = kRGBColor(217, 217, 217).CGColor;
                    [button.layer addSublayer:rightBorder];
                }
                if (i == _cellType) {
                    _currentButton = button;
                    button.selected = YES;
                }
                [button bk_addEventHandler:^(UIButton *sender) {
                    if (sender != _currentButton) {
                        _currentButton.selected = NO;
                        sender.selected = YES;
                        _currentButton = sender;
                        _cellType = (int)sender.tag;
                        [self isRefresh:YES];
                        YSHLog(@"sender:%d",(int)sender.tag);
                    }
                } forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:button];
            }
            return bgView;
        }

    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JYLoopCellIndentifier];
                if (cell == nil ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JYLoopCellIndentifier];
                    /**  加入滚动视图 */
                    //                self.firstLoopView.frame = CGRectMake(0, 0, kWindowW, firstLVH);
                    [cell addSubview:self.firstLoopView];
                    [self.firstLoopView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                    /**  加入pageview */
                    self.firstLoopPage.numberOfPages = self.firstLoopView.numberOfItems;
                    [cell addSubview:self.firstLoopPage];
                    [self.firstLoopPage mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.mas_equalTo(0);
                        make.bottom.mas_equalTo(10);
                    }];
                }
                return cell;
            }
            if (indexPath.row == 1) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JYLoopCellSecondIndentifier];
                if  (cell == nil ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JYLoopCellSecondIndentifier];
                    /**  加入滚动视图 */
                    [cell addSubview:self.secondLoopView];
                    [self.secondLoopView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(0);
                    }];
                }
                return cell;
            }
        }
        else if (indexPath.section ==1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JYLoopCellThirdIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JYLoopCellThirdIndentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSLog(@"%@",NSStringFromCGRect(cell.frame));
                //添加最新活动label
                UILabel *label = [UILabel new];
                label.text = @"最新活动";
                label.font = [UIFont systemFontOfSize:14];
                [cell addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(7.5, 10, 117.5, 250));
                }];
                //添加更多button
                UIButton *button = [UIButton new];
                [button setTitle:@"更多" forState:UIControlStateNormal];
                [button setTitleColor:kRGBColor(182, 182, 182) forState:UIControlStateNormal];
                
                
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                UIImage *imageArrow = [UIImage imageNamed:@"message_10"];
                [button setImage:imageArrow forState:UIControlStateNormal];
                //            button.backgroundColor = [UIColor redColor];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageArrow.size.width-15, 0, imageArrow.size.width+15)];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width+15, 0, -button.titleLabel.bounds.size.width-15)];
                //button方法
                [button bk_addEventHandler:^(id sender) {
                    NSLog(@"更多");
                } forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(0, 265, 110, 0));
                }];
                
                /**  加入滚动视图 */
                [cell addSubview:self.thirdLoopView];
                [self.thirdLoopView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(30, 0, 10, 0));
                }];
            }
            return cell;
        }
        else if (indexPath.section == 2){
            switch (_cellType) {
                case homeProduct: {
                    JYHomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:JYHomeProductCellIndentifier];
                    //                if (self.goodsVM.dataArr.count != 0) {
                    if (!_firstGoodsArray) {
                        _firstGoodsArray = self.goodsVM.dataArr;
                    }
#warning 可能会崩溃在下一行
                    if (_firstGoodsArray.count > 0) {
                        cell.goodsItems = _firstGoodsArray[indexPath.row];
                        [cell setAttribute];
                    }
                   
                    //                }
                    return cell;
                }
                    break;
                case recommend:{
                    JYRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:JYRecommendCellIndentifier];
                    if (self.goodsVM.dataArr.count != 0) {
                        if (_secondGoodsArray == nil) {
                            _secondGoodsArray = self.goodsVM.dataArr;
                        }
                        cell.goodsItems = _secondGoodsArray[indexPath.row];
                        [cell setAttribute];
                    }
                    
                    return cell;
                }
                    break;
                case freeCharge: {
                    JYFreeChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:JYChargeCellIndentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (self.goodsVM.dataArr.count != 0) {
                        cell.rootController = self.navigationController;
                        cell.firstGoodsItem = self.goodsVM.dataArr[2*indexPath.row];
                        cell.secondGoodsItem = self.goodsVM.dataArr[2*indexPath.row  + 1];
                        [cell setAttribute];
                    }
                    return  cell;
                    
                }
            }
        }
    }
    else {
        JYClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        cell.currentPrice.text = @"100";
        return cell;
    }
 
    return nil;

}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择痕迹
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_cellType != freeCharge && indexPath.section == 2) {
        JYProductDetailVC *productDetailVC = [[JYProductDetailVC alloc] init];
        JYGoodsItems *item = self.goodsVM.dataArr[indexPath.row];
        productDetailVC.goodsID = item.ID;
        productDetailVC.schoolName = item.schoolname;
        NSLog(@"商品ID:%@",item.ID);
        
        productDetailVC.title = @"商品详情";
        productDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
}
#pragma mark - 方法封装
/**  生成params参数 */
-(NSDictionary *)setParams {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"page"] = [NSString stringWithFormat:@"%d",_page];
    params[@"title"] = self.goodsTitleArray[_cellType];
    params[@"sort"] = @"all";
    return  [params copy];
}
/**  发送请求并刷新 */
-(void)isRefresh:(BOOL) isRefresh{
    _page = isRefresh ? 1 : _page+1;
    self.goodsVM.params = [self setParams];
    if (isRefresh) {
        [self.goodsVM refreshDataCompletionHandle:^(NSError *error) {
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        }];
    }else {
        [self.goodsVM getMoreDataCompletionHandle:^(NSError *error) {
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];

        }];
    }
}
@end
