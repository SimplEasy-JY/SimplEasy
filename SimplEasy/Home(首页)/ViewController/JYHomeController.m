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
@interface JYHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ImageScrollViewDelegate>{
    /**< 第一个轮播数据 */
    NSMutableArray *_focusListArray;
    /**< 第一个轮播图片URL数据 */
    NSMutableArray *_focusImgurlArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray *imageArray ;
@property(strong,nonatomic)JYLoopViewModel *loopVM;


@end

@implementation JYHomeController
-(JYLoopViewModel *)loopVM{
    if (!_loopVM) {
        _loopVM = [JYLoopViewModel new];
    }
    return _loopVM;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self setNav];
    [self setupTableView];


}
-(NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSArray new];
    }
    return _imageArray;
}

-(void)initData{

}
-(void)setNav{
    //中间的搜索条
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    /**  设置自定义搜索图片 */
    [searchBar setImage:[UIImage imageNamed:@"topicon_3"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
#warning 后台数据替换
    searchBar.placeholder = @"简易破蛋日全场大甩卖";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

-(void)setupTableView{
        [self.loopVM getDataFromNetCompleteHandle:^(NSError *error) {
            [self.tableView reloadData];
            YSHLog(@"获取数据");
        }];
   
    //下拉刷新
    DGElasticPullToRefreshLoadingViewCircle *loadingView = [DGElasticPullToRefreshLoadingViewCircle new];
    loadingView.tintColor = [UIColor blueColor];
    [self.tableView dg_addPullToRefreshWithActionHandler:^{
            [self.tableView dg_stopLoading];
        
    } loadingView:loadingView];
    [self.tableView dg_setPullToRefreshBackgroundColor:self.tableView.backgroundColor];
    [self.tableView dg_setPullToRefreshFillColor:kRGBColor(52, 152, 82)];
    
    //
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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
            return 150;
        }else {
            return 30;
        }

    }else if (indexPath.section == 1){
        return 140;
    }else {
//        return UITableViewAutomaticDimension;
        return 270;
    }
    
    
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
    }else {
        return 270;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellIndentifier = @"courseCell0";
            ImageScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (self.loopVM.loopImageUrlArray != nil) {
                cell = [[ImageScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier frame:CGRectMake(0, 0, kWindowW, 116) imageArray:self.loopVM.loopImageUrlArray];
            }
            cell.imageScrollView.delegate = self;
            
    
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

    
    static NSString *cellIndentifier = @"courseCell1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    JYProductDetailVC *productDetailVC = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"JYProductDetailVC"];
    productDetailVC.title = @"商品详情";
    productDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}
@end
