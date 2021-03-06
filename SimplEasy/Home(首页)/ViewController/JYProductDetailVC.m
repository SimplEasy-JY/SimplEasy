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
#import "UMSocial.h"//导入友盟分享，用于分享按钮

static CGFloat bottomBtnWidth = 40;
static CGFloat bottomBtnHeight = 50;

@interface JYProductDetailVC ()<UITableViewDelegate,UITableViewDataSource,iCarouselDelegate,iCarouselDataSource,MWPhotoBrowserDelegate,UMSocialUIDelegate>
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
    [JYFactory addBackItemToVC:self];
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    
    //获取数据
    [self.pdVM getDataFromNetCompleteHandle:^(NSError *error) {
        if (error) {
            JYLog(@"ERROR:%@",error.description);
        }
        JYLog(@"得到数据");
        [self configTableViewHeader];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];

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
    /** 如果只有一张图，则不允许滚动 */
    if ([self.pdVM picArrForProduct].count == 1) {
        self.icView.scrollEnabled = NO;
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
    NSArray *btnImages = @[@"pd_eye.jpg",@"pd_comment",@"pd_heart"];
    NSArray *btnHighlightedImages = @[@"pd_eye.jpg",@"pd_comment",@"pd_heart_highlighted"];
    NSArray *btnBgColors = @[kRGBColor(60, 183, 21),kRGBColor(55, 150, 84),kRGBColor(245, 245, 245)];
    
    for (int i = 0; i < btnImages.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:btn];
        //text
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        //image
        [btn setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btnHighlightedImages[i]] forState:UIControlStateHighlighted];
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

#pragma mark *** 友盟分享 ***

/** 分享按钮点击操作 */
- (void)share{
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [self.pdVM urlStrForProduct];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [self.pdVM urlStrForProduct];
    [UMSocialData defaultData].extConfig.qqData.url = [self.pdVM urlStrForProduct];
    [UMSocialData defaultData].extConfig.qzoneData.url = [self.pdVM urlStrForProduct];
    //设置分享的title
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [self.pdVM shareTitle];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [self.pdVM shareTitle];
    [UMSocialData defaultData].extConfig.qqData.title = [self.pdVM shareTitle];
    [UMSocialData defaultData].extConfig.qzoneData.title = [self.pdVM shareTitle];
    
    //获取SDWebImage缓存的图片
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[self.pdVM picArrForProduct].firstObject]];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppKey
                                      shareText:[self.pdVM nameForProduct]
                                     shareImage:cacheImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,UMShareToQzone,nil]
                                       delegate:self];
}

/** 友盟分享实现回调方法（可选）： */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [@[@3,@3][section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {/** 如果是第一个cell分区，那么只需要配置商品详情cell和商家信息cell */
        if (indexPath.row == 0) {

            /** 商品详情cell */
            JYProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYProductDetailCell"];
            if (cell == nil) {
                cell = [[JYProductDetailCell alloc] init];
            }
            cell.productDescLb.text = [self.pdVM nameForProduct];//商品描述
            cell.currentPriceLb.text = [self.pdVM currentPriceForProduct];//当前价格
            cell.originPriceLb.text = [self.pdVM originPriceForProduct];//原始价格
            cell.originPriceLb.text?[cell.originPriceLb addMidLine]:nil;//如果有原始价格，则加入删除线
            [cell addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside]; //添加点击事件
            /** 需要先设置地点再设置时间，否则约束会乱，如果没有地点就不用设置 */
            (self.schoolName && self.schoolName.length>0)?cell.placeLb.text = self.schoolName:nil;//学校名称
            cell.publishTimeLb.text = [self.pdVM publishTimeForProduct];//发布时间
            return cell;
        }else if(indexPath.row == 1){
            
            /** 商家信息cell */
            JYSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSellerCell"];
            if (cell == nil) {
                cell = [[JYSellerCell alloc] init];
            }
            [cell.headIV sd_setImageWithURL:[self.pdVM headImageForSeller]];
            cell.nickNameLb.text = [self.pdVM nameForSeller];// 设置昵称
            if (self.schoolName && self.schoolName.length>0) {
                cell.schoolLb.text = self.schoolName;// 设置学校
            }
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = [self.pdVM descForProduct];
            cell.textLabel.numberOfLines = 0;
            return cell;
        }
        
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
        if (cell == nil) {
            cell = [[JYCommentCell alloc] init];
        }
        cell.headIV.image = [UIImage imageNamed:@"picture_46"];
        cell.nickNameLb.text = @"评论人";
        cell.timeLb.text = @"11-5 13:28";
        cell.rankIV.image = [UIImage imageNamed:@"picture_38"];
        cell.commentLb.text = @"我最近正想买个洗脸仪呢，这个真的好用么？味全丹麦活性菌，源自丹麦©SINCE1916.";
        return cell;
    }
    return nil;
}

#pragma mark *** <UITableViewDelegate> ***

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?0:20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
        
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
        
        MBRoundProgressView *roundView = [[MBRoundProgressView alloc] init];
        [imageView addSubview:roundView];
        roundView.tag = 300;
        roundView.progressTintColor = JYGlobalBg;
        roundView.backgroundTintColor = [UIColor whiteColor];
        roundView.annular = YES;
        roundView.hidden = YES;
        [roundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
    }
    //根据tag取出View
    UIImageView *bgImageView = (UIImageView *)[view viewWithTag:200];
    UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
    MBRoundProgressView *roundView = (MBRoundProgressView *)[view viewWithTag:300];
    
    NSURL *url = [self.pdVM picArrForProduct][index];
    
    [imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            roundView.progress = receivedSize*1.0/expectedSize;
            roundView.hidden = receivedSize == expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            JYLog(@"加载图片出错: %@",error.description);
        }
        imageView.image = image;
        bgImageView.image = image;
    }];
    
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

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark *** MWPhotoBrowserDelegate ***

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return [self.pdVM picArrForProduct].count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < [self.pdVM picArrForProduct].count) {
        return [MWPhoto photoWithURL:[self.pdVM picArrForProduct][index]];
    }
    return nil;
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
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [UIView new];
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
