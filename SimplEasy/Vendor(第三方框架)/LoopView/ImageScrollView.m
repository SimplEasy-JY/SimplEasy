//
//  ImageScrollView.m
//  smgui
//
//  Created by 杨胜浩 on 15/5/25.
//  Copyright (c) 2015年 yangshenghao. All rights reserved.
//

#import "ImageScrollView.h"
#import "UIImageView+WebCache.h"

@interface ImageScrollView ()<UIScrollViewDelegate>
{
    NSTimer *_timer;
    int _pageNumber;
}

@end

@implementation ImageScrollView
#pragma mark -重写初始化方法
-(ImageScrollView *)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray{
    self = [super initWithFrame:frame];
     _pageNumber = (int)imageArray.count;
    if (self) {
        //创建scrollview
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        /**  横滚 */
        self.scrollView.contentSize = CGSizeMake(imageArray.count*frame.size.width, frame.size.height);
//        /**  竖滚 */
//        self.scrollView.contentSize = CGSizeMake(frame.size.width, imageArray.count*frame.size.height);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        //添加图片
        for(int i = 0 ; i <  imageArray.count; i++){
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height);
            /**  提供协议数据 */
            imageView.tag = i+10;
             NSString *imageURL =[NSString stringWithFormat:@"%@",imageArray[i]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"lesson_default"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            [self.scrollView addSubview:imageView];
        }
        [self addSubview:self.scrollView];
        
        //
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.size.width/2-40, frame.size.height-20, 80, 20)];
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = imageArray.count;
        [self addSubview:self.pageControl];
        
        [self addTimer];
    }
    return self;
}





-(void)OnTapImage:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    int tag = (int)imageView.tag-10;
    [self.delegate didSelectImageAtIndex:tag];
}

-(void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(netxPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)removeTimer{
    [_timer invalidate];
}

-(void)netxPage{
    int page = (int)self.pageControl.currentPage;
    if (page == _pageNumber-1) {
        page = 0;
    }else{
        page++;
    }
    //滚动scrollview
    CGFloat x = page*self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);
}

#pragma mark - UIScrollViewDelegate
//滑动时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    self.pageControl.currentPage = page;
}
//开始拖动时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
//结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

-(void)dealloc{
    [self removeTimer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end