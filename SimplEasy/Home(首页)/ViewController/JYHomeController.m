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
#import "ImageScrollView.h"
#import "JYLoopViewModel.h"
#import "JYWebViewController.h"

#import "JYHomeProductCell.h"
#import "JYRecommendCell.h"
#import "JYFreeChargeCell.h"

#import "UIImage+Circle.h"
/**  cell id */
static NSString *JYLoopCellIndentifier = @"loopCell";
static NSString *JYLoopCellSecondIndentifier = @"loopSecondCell";
static NSString *JYHomeProductCellIndentifier = @"JYHomeProductCell";
static NSString *JYRecommendCellIndentifier = @"JYRecommendCell";
static NSString *JYChargeCellIndentifier = @"freeChargeCell";

@interface JYHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,iCarouselDelegate,iCarouselDataSource>{
    /**< 第一个轮播数据 */
    NSMutableArray *_focusListArray;
    /**< 第一个轮播图片URL数据 */
    NSMutableArray *_focusImgurlArray;
//    /**  type */
    int _cellType;
    /**  当前button */
    UIButton *_currentButton;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)categoryButton:(id)sender;
- (IBAction)positionButton:(id)sender;

@property(strong,nonatomic)JYLoopViewModel *loopVM;

/**  顶部轮播 */
@property(strong,nonatomic)iCarousel *firstLoopView;
@property(strong,nonatomic)UIPageControl *firstLoopPage;
@property(strong,nonatomic)iCarousel *secondLoopView;
/**  segmented Control */
@property(strong,nonatomic)NSArray *segmentItemsArray;




@end

@implementation JYHomeController
#pragma mark -枚举
typedef NS_ENUM(NSInteger, cellType) {
    //以下是枚举成员
    homeProduct = 0,
    recommend = 1,
    freeCharge = 2,
};
#pragma mark -懒加载
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
        _secondLoopView.vertical = YES;
        //改为翻页模式
        _secondLoopView.pagingEnabled = YES;
    }
    return _secondLoopView;
    
}

-(UIPageControl *)firstLoopPage{
    if (!_firstLoopPage) {
        self.firstLoopPage = [[UIPageControl  alloc]init];
        _firstLoopPage.numberOfPages = self.firstLoopView.numberOfItems;
        _firstLoopPage.currentPage = self.firstLoopView.currentItemIndex;
        _firstLoopPage.currentPageIndicatorTintColor = [UIColor whiteColor];
        _firstLoopPage.pageIndicatorTintColor = [UIColor blackColor];
    }
    return _firstLoopPage;
    
}
-(JYLoopViewModel *)loopVM{
    if (!_loopVM) {
        _loopVM = [JYLoopViewModel new];
    }
    return _loopVM;
}

#pragma mark - 响应方法
/**  分类按钮 */
- (IBAction)categoryButton:(id)sender {
    [kAppDelegate.sideMenu presentLeftMenuViewController];
}
/**  定位按钮 */
- (IBAction)positionButton:(id)sender {
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
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

}


-(void)initData{

}
-(void)setNav{
    //中间的搜索条
    CGRect frame = CGRectMake(0, 0, 190, 28);
    /**  加中间层，防止切换闪 */
    UIView *titleView = [[UIView alloc] initWithFrame:frame];
    UIColor *color =  [UIColor whiteColor];
    [titleView setBackgroundColor:color];
    titleView.layer.cornerRadius = 15;
    titleView.layer.masksToBounds = YES;
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:frame];
    /**  设置自定义搜索图片 */
    [searchBar setImage:[UIImage imageNamed:@"topicon_3"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.masksToBounds = YES;
    
    
#warning 后台数据替换
    searchBar.placeholder = @"老板娘怀孕，全场免费~";
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
}

-(void)setupTableView{
        [self.loopVM getDataFromNetCompleteHandle:^(NSError *error) {
            [self.tableView reloadData];
            [self.firstLoopView reloadData];
            YSHLog(@"获取数据");
        }];
   
    //下拉刷新
    DGElasticPullToRefreshLoadingViewCircle *loadingView = [DGElasticPullToRefreshLoadingViewCircle new];
    loadingView.tintColor = [UIColor blueColor];
    [self.tableView dg_addPullToRefreshWithActionHandler:^{
        
        [self.tableView reloadData];
        [self.tableView dg_stopLoading];
    } loadingView:loadingView];
    [self.tableView dg_setPullToRefreshBackgroundColor:self.tableView.backgroundColor];
    [self.tableView dg_setPullToRefreshFillColor:JYGlobalBg];
    
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
    return 0;
    
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (carousel == _firstLoopView){
        if (!view) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, firstLVH)];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = 100;
            [view addSubview: imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(view);
            }];
        }
        UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.loopVM.loopImageUrlArray[index]] placeholderImage:nil];
        return view;
    }else if (carousel == _secondLoopView){
        if (!view) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, firstLVH, kWindowW, secondLVH)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            imageView.backgroundColor = [UIColor yellowColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kWindowW-30, 30)];
            label.text =  @"test~test~test~test~test~test~";
            
            [view addSubview:imageView];
            [view addSubview:label];
        }
        return  view;
    }
    return  nil;
}

/**  添加循环滚动 */
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return YES;
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
        return 10;
    }
}
/**  cell高度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 116;
        }else {
            return 30;
        }

    }else if (indexPath.section == 1){
        return 140;
    }else {
        switch (_cellType) {
            case homeProduct:{
//                JYHomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:JYHomeProductCellIndentifier];
//                CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//                return height;
                return 280;
                break;
            }
                
                
            case recommend:{
                JYRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:JYRecommendCellIndentifier];
                CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                return height;
                break;
            }
            case freeCharge:{
                JYFreeChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:JYChargeCellIndentifier];
                CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                return height;
                break;
            }
               
                
        }
        return 270;
    }

//        return UITableViewAutomaticDimension;
    
    
}

/**  首次加载cell的高度， 提高性能 */
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 116;
        }else {
            return 30;
        }
    }else if (indexPath.section == 1){
        return 140;
    }else  {
        return 280;
    }
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
            [[button layer]setBorderWidth:0.5];
            [[button layer]setBorderColor:kRGBColor(217, 217, 217).CGColor];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:JYGlobalBg cornerRadius:0] forState:UIControlStateSelected];
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
                    NSInteger index = 2;
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
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
            if (self.loopVM.loopImageUrlArray != nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JYLoopCellIndentifier];
                /**  加入滚动视图 */
                [cell addSubview:self.firstLoopView];
                [self.firstLoopView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];
                /**  加入pageview */
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JYLoopCellSecondIndentifier];
            /**  加入滚动视图 */
            [cell addSubview:self.secondLoopView];
            [self.secondLoopView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return cell;
        }
    }

    else if (indexPath.section == 2){
        switch (_cellType) {
            case homeProduct: {

                JYHomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:JYHomeProductCellIndentifier];
                    cell.userImageView.image = [UIImage circleImageWithImage:[UIImage imageNamed:@"headerImage"] borderWidth:0.5 borderColor:[UIColor whiteColor]];
                if (indexPath.row == 0) {
                    cell.describeLabel.text = @"dagjf dasf gdak fgdks gf dksaghf dkhag fkdhag fd反倒是飞洒发飞";
                    cell.shopImageOne.hidden = YES;
                    cell.originalPrice.hidden =YES;
                    cell.shopImageThree.hidden = YES;
                    cell.shopImageTwo.hidden = YES;
                
                }
             
                return cell;
            }
                break;
            case recommend:{

                JYRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:JYRecommendCellIndentifier];
                cell.describeLabel.text = @"dagjf dasf gdak fgdks gf dksaghf dkhag fkdhag fd反倒是飞洒发飞";
                cell.currentPrice.text = @"1000";
                cell.shopImage.image = [UIImage scaleToSize:[UIImage imageNamed:@"picture_15"] size:CGSizeMake(110.0, 82.0)];

                return cell;
            }
                break;
            case freeCharge: {
                JYFreeChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:JYChargeCellIndentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.goodsId = 10;
                
                return  cell;
                
            }
        }
    }
    
        
    

    static NSString *cellIndentifier = @"courseCell1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellType%d",_cellType);
    //取消选择痕迹
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cellType != freeCharge) {
        JYProductDetailVC *productDetailVC = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"JYProductDetailVC"];
        productDetailVC.title = @"商品详情";
        productDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
    NSLog(@"%ld",(long)indexPath.row);
   

}

@end
