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

#import "JYLoopViewModel.h"
#import "JYGoodsViewModel.h"

#import "JYHomeProductCell.h"
#import "JYRecommendCell.h"
#import "JYFreeChargeCell.h"

#import "UIImage+Circle.h"

#import "JYLoginViewController.h"
/**  cell id */
static NSString *JYLoopCellIndentifier = @"loopCell";
static NSString *JYLoopCellSecondIndentifier = @"loopSecondCell";
static NSString *JYLoopCellThirdIndentifier = @"loopThirdCell";
static NSString *JYHomeProductCellIndentifier = @"JYHomeProductCell";
static NSString *JYRecommendCellIndentifier = @"JYRecommendCell";
static NSString *JYChargeCellIndentifier = @"freeChargeCell";

@interface JYHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,iCarouselDelegate,iCarouselDataSource>{
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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)categoryButton:(id)sender;
- (IBAction)positionButton:(id)sender;

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
        //滚动速度
        _firstLoopView.scrollSpeed = 2;
        
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
#pragma mark - 响应方法
/**  分类按钮 */
- (IBAction)categoryButton:(id)sender {
    JYClassifyViewController *classifyVC = (JYClassifyViewController *)self.sideMenuViewController.leftMenuViewController;
    
    [classifyVC didSelectTypeWithBlock:^(JYClassifyContentVC *viewController, NSString *selectedType) {
        viewController.title = selectedType;
        viewController.type = selectedType;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    [self.sideMenuViewController presentLeftMenuViewController];
}
/**  定位按钮 */
- (IBAction)positionButton:(id)sender {
    JYLoginViewController *vc = [[JYLoginViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    //刷新
    [self.tableView.header beginRefreshing];

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
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:frame];

    /**  设置自定义搜索图片 */
    
    [searchBar setImage:[UIImage imageNamed:@"topicon_3"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //设置背景颜色
    UIView *searchTextField = nil;
    searchBar.barTintColor = [UIColor whiteColor];
    searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = kRGBColor(240, 240, 240);

    
    
#warning 后台数据替换
    searchBar.placeholder = @"简易破蛋人大酬宾~";
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;

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
    
    //加载数据
    [self isRefresh:YES];
    
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self isRefresh:YES];
    }];
    //添加上拉加载
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self isRefresh:NO];
    }];
    
    //cell的分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
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
    if (carousel == _firstLoopView){
        if (!view) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, firstLVH)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, firstLVH)];
            imageView.tag = 100;
            [view addSubview: imageView];
//            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(view);
//            }];
        }
        UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.loopVM.loopImageUrlArray[index]] placeholderImage:nil];
        return view;
    }else if (carousel == _secondLoopView){
        if (!view) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, firstLVH, kWindowW, secondLVH)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kWindowW-30, 30)];
            imageView.tag = 100;
            label.tag = 101;
            [view addSubview:imageView];
            [view addSubview:label];
        }
        UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
        imageView.image = [UIImage imageNamed:@"middleicon_15"];
        UILabel *label = (UILabel *)[view viewWithTag:101];
        label.text =  @"【急需】求购二手小电驴，价格1500左右 ";
        label.font = [UIFont systemFontOfSize:13];
        return  view;
    }else if (carousel == _thirdLoopView) {
        if (!view) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (kWindowW-20)/2, 100)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (kWindowW-20)/2, 100 )];
            imageView.tag = 100;
            imageView.backgroundColor = [UIColor yellowColor];
            [view addSubview:imageView];
        }
        UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
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



#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

/**  cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else if(section == 1) {
        return 1;
    } else {
        if (_cellType == 2) {
            return (self.goodsVM.dataArr.count / 2 + (self.goodsVM.dataArr.count%2 == 0 ?0:1));
            
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
    if (section == 2) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 30)];
        /**  设置边框宽度和颜色 */
        [[bgView layer]setBorderWidth:0.5];
        [[bgView layer]setBorderColor:kRGBColor(217, 217, 217).CGColor];
        for (int i=0; i<self.segmentItemsArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            /**  设置button的参数 */
            if (i == 1) {
                [[button layer]setBorderWidth:1];
                [[button layer]setBorderColor:kRGBColor(217, 217, 217).CGColor];
            }
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:JYHexColor(0x272C35) cornerRadius:0] forState:UIControlStateSelected];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:self.segmentItemsArray[i] forState:UIControlStateNormal];
            [button setTitleColor:kRGBColor(54, 54, 54) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.frame = CGRectMake(0+kWindowW/self.segmentItemsArray.count*i, 0, kWindowW/self.segmentItemsArray.count, 30);
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
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JYLoopCellIndentifier];
            if (cell == nil ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JYLoopCellIndentifier];
                /**  加入滚动视图 */
                self.firstLoopView.frame = CGRectMake(0, 0, kWindowW, firstLVH);
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
//            NSLog(@"%@",NSStringFromCGRect(self.firstLoopView.frame));
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
                if (self.goodsVM.dataArr.count != 0) {
                    if (!_firstGoodsArray) {
                        _firstGoodsArray = self.goodsVM.dataArr;
                        
                    }
                    cell.goodsItems = _firstGoodsArray[indexPath.row];
                    [cell setAttribute];
                }
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
