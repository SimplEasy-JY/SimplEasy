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
@interface JYHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,iCarouselDelegate,iCarouselDataSource>{
    /**< 第一个轮播数据 */
    NSMutableArray *_focusListArray;
    /**< 第一个轮播图片URL数据 */
    NSMutableArray *_focusImgurlArray;
    /**  type */
    int _type;
    /**  当前button */
    UIButton *_currentButton;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)categoryButton:(id)sender;
- (IBAction)positionButton:(id)sender;

@property(strong,nonatomic)JYLoopViewModel *loopVM;

/**  顶部轮播 */
@property(strong,nonatomic)iCarousel *loopView;
@property(strong,nonatomic)UIPageControl *loopPage;

/**  segmented Control */
@property(strong,nonatomic)NSArray *segmentItemsArray;




@end

@implementation JYHomeController
#pragma mark -懒加载
-(NSArray *)segmentItemsArray{
    if (!_segmentItemsArray) {
        self.segmentItemsArray = [[NSArray  alloc]initWithObjects:@"今日上新",@"精选推荐",@"免费易货",nil];
    }
    return _segmentItemsArray;
    
}

-(iCarousel *)loopView{
    if (!_loopView) {
        self.loopView = [[iCarousel  alloc]init];
        //就是仿写的CollectionView
        _loopView.delegate = self;
        _loopView.dataSource = self;
        //修改3D显示模式
        _loopView.type = iCarouselTypeLinear;
        //自动展示,0表示不滚动，越大滚动越快
        _loopView.autoscroll = 0;
        //水平还是垂直  no水平
        _loopView.vertical = NO;
        //改为翻页模式
        _loopView.pagingEnabled = YES;
        //滚动速度
        _loopView.scrollSpeed = 2;
        
    }
    return _loopView;
}
-(UIPageControl *)loopPage{
    if (!_loopPage) {
        self.loopPage = [[UIPageControl  alloc]init];
        _loopPage.numberOfPages = self.loopView.numberOfItems;
        _loopPage.currentPage = self.loopView.currentItemIndex;
        _loopPage.currentPageIndicatorTintColor = [UIColor whiteColor];
        _loopPage.pageIndicatorTintColor = [UIColor blackColor];
        
        
    }
    return _loopPage;
    
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
        [self.loopView scrollToItemAtIndex:self.loopView.currentItemIndex+1 animated:YES];
    } repeats:YES];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"JYHomeProductCell" bundle:nil] forCellReuseIdentifier:@"JYHomeProductCell"];



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
            [self.loopView reloadData];
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
    
    //
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
}
#pragma mark *** iCarouselDatasource & iCarouseDelegate ***

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.loopVM.loopImageUrlArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 116)];
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
}

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
    self.loopPage.currentPage = carousel.currentItemIndex;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"选择了第%ld张",index);
    
    JYWebViewController *JYWebVC = [[JYWebViewController alloc]init];
    NSString *webUrl = [NSString stringWithFormat:@"http://%@",self.loopVM.loopWebUrlArray[index]];
    JYWebVC.webUrl = webUrl;
    JYWebVC.hidesBottomBarWhenPushed = YES;
    
    JYWebVC.title = @"这里是自定义标题";
    [self.navigationController pushViewController:JYWebVC animated:YES];

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
        return 270;
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
            if (i == _type) {
                _currentButton = button;
                button.selected = YES;
            }
            [button bk_addEventHandler:^(UIButton *sender) {
                if (sender != _currentButton) {
                    _currentButton.selected = NO;
                    sender.selected = YES;
                    _currentButton = sender;
                    
                    _type = (int)sender.tag;
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
            static NSString *cellIndentifier = @"loopCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (self.loopVM.loopImageUrlArray != nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                [cell addSubview:self.loopView];
                
                [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];
                [cell addSubview:self.loopPage];
                [self.loopPage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(cell);
                    make.bottom.mas_equalTo(10);
                }];
            }
            
            
            return cell;
        }
    }
//        }else if (indexPath.row == 1){
//            static NSString *cellIndentifier = @"courseCell1";
//            JZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//            if (cell == nil) {
//                cell = [[JZAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier frame:CGRectMake(0, 0, screen_width, 90)];
//                //下划线
//                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 89.5, screen_width, 0.5)];
//                lineView.backgroundColor = separaterColor;
//                [cell addSubview:lineView];
//            }
//            
//            cell.delegate = self;
//            [cell setImgurlArray:_albumImgurlArray];
//            
//            return cell;
//        }else if (indexPath.row > 1){
//            static NSString *cellIndentifier = @"courseCell2";
//            JZCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//            if (cell == nil) {
//                cell = [[JZCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
//                //            NSLog(@"%f/%f",cell.frame.size.width,cell.frame.size.height);
//                //下划线
//                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 71.5, screen_width, 0.5)];
//                lineView.backgroundColor = separaterColor;
//                [cell addSubview:lineView];
//            }
//            
//            JZCourseListModel *jzCourseM = _courseListArray[indexPath.row-2];
//            [cell setJzCourseM:jzCourseM];
//            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
//            return cell;
//        }
//        static NSString *cellIndentifier = @"courseCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
//        }
//        
//        return cell;
//    }else{
//        static NSString *cellIndentifier = @"courseClassCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
//            //下划线
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, screen_width, 0.5)];
//            lineView.backgroundColor = separaterColor;
//            [cell addSubview:lineView];
//            //图
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
//            imageView.tag = 10;
//            [cell addSubview:imageView];
//            //标题
//            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 100, 30)];
//            titleLabel.tag = 11;
//            [cell addSubview:titleLabel];
//        }
//        NSDictionary *dataDic = _classCategoryArray[indexPath.row];
//        UIImageView *imageView = (UIImageView *)[cell viewWithTag:10];
//        NSString *imageStr = [dataDic objectForKey:@"image"];
//        [imageView setImage:[UIImage imageNamed:imageStr]];
//        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
//        titleLabel.text = [dataDic objectForKey:@"title"];
//        
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        return cell;
//    }
    else if (indexPath.section == 2){
        static NSString *cellIndentifier = @"JYHomeProductCell";
        JYHomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (indexPath.row == 1) {
            cell.describeLabel.text = @"dagjf dasf gdak fgdks gf dksaghf dkhag fkdhag fdsa";
        }else if (indexPath.row == 2){
            cell.shopImageOne.hidden = YES;
            cell.originalPrice.hidden =YES;
            cell.shopImageThree.hidden = YES;
            cell.shopImageTwo.hidden = YES;
        }
        
        return cell;
            
    }

    static NSString *cellIndentifier = @"courseCell1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择痕迹
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld",(long)indexPath.row);
    JYProductDetailVC *productDetailVC = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"JYProductDetailVC"];
    productDetailVC.title = @"商品详情";
    productDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

@end
