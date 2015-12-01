//
//  JYPublishIdleView.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/1.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPublishIdleView.h"

static CGFloat normalH = 44;
static CGFloat descH = 85;
static CGFloat imageH = 100;
static CGFloat margin = 10;

@implementation JYPublishIdleView 


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        [self configView];
    }
    return self;
}


- (void)configView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //滚动视图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;//设置代理
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];//背景颜色
    [self addSubview: _scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {//约束
        make.edges.mas_equalTo(0);
    }];
    
    //上部分背景视图
    UIView *infoView = [UIView new];
    infoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(kWindowW);
    }];
    
    self.titleTF = [[UITextField alloc] init];
    _titleTF.placeholder = @"标题";
    _titleTF.delegate = self;
    [infoView addSubview:_titleTF];
    [_titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.right.mas_equalTo(infoView.mas_right).mas_equalTo(-margin);
        make.height.mas_equalTo(normalH);
    }];
    
    self.descTV = [[UITextView alloc] init];
    _descTV.text = @"描述一下您的物品...";
    _descTV.textColor = [UIColor lightGrayColor];
    _descTV.font = [UIFont systemFontOfSize:14];
    _descTV.delegate = self;
    [infoView addSubview:_descTV];
    [_descTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleTF.mas_bottom).mas_equalTo(margin);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(infoView.mas_right).mas_equalTo(-margin);
        make.height.mas_equalTo(descH);
    }];
    
    /** 为TExtView加一个手势，下滑回收键盘 */
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [_descTV resignFirstResponder];
    }];
    swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [_descTV addGestureRecognizer:swipeGR];
    
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageBtn setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [infoView addSubview: _imageBtn];
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_descTV.mas_bottom).mas_equalTo(margin);
        make.left.mas_equalTo(margin);
        make.size.mas_equalTo(CGSizeMake(imageH, imageH));
    }];
    
    //添加点击事件
    [self.imageBtn bk_addEventHandler:^(id sender) {
        JYLog(@"加图片加图片加图片加图片加图片加图片加图片");
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_locationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_locationBtn setTitle:@"浙江传媒学院" forState:UIControlStateNormal];
    [_locationBtn setImage:[UIImage imageNamed:@"location_07"] forState:UIControlStateNormal];
    [infoView addSubview:_locationBtn];
    [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageBtn.mas_bottom).mas_equalTo(margin);
        make.left.mas_equalTo(margin);
        make.bottom.mas_equalTo(-margin);
    }];
    
    //下半部分背景view
    UIView *publishView = [UIView new];
    publishView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:publishView];
    [publishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoView.mas_bottom).mas_equalTo(margin);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kWindowW);
        make.height.mas_equalTo(3*normalH+10);
    }];
    
    UILabel *priceLb = [[UILabel alloc] init];
    priceLb.text = @"价格";
    priceLb.textColor = [UIColor darkGrayColor];
    [publishView addSubview:priceLb];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kWindowW/4-margin/2, normalH));
    }];
    
    self.priceTF = [[UITextField alloc] init];
    _priceTF.placeholder = @"¥0.00";
    _priceTF.delegate = self;
    [publishView addSubview:_priceTF];
    [_priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLb.mas_right).mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kWindowW/4, normalH));
    }];
    
    UILabel *originPriceLb = [[UILabel alloc] init];
    originPriceLb.text = @"原价";
    originPriceLb.textColor = [UIColor darkGrayColor];
    [publishView addSubview:originPriceLb];
    [originPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_priceTF.mas_right).mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kWindowW/4-margin/2, normalH));
    }];
    
    self.originPriceTF = [[UITextField alloc ] init];
    _originPriceTF.placeholder = @"¥0.00";
    _originPriceTF.delegate = self;
    [publishView addSubview:_originPriceTF];
    [_originPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(originPriceLb.mas_right).mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kWindowW/4, normalH));
    }];
    
    UILabel *classLb = [[UILabel alloc] init];
    classLb.text = @"分类";
    classLb.textColor = [UIColor darkGrayColor];
    [publishView addSubview: classLb];
    [classLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(priceLb.mas_bottom).mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kWindowW/4-margin/2, normalH));
    }];
    
    self.classTF = [[UITextField alloc] init];
    _classTF.placeholder = @"请选择分类";
    _classTF.delegate = self;
    [publishView addSubview:_classTF];
    [_classTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(originPriceLb.mas_bottom).mas_equalTo(0);
        make.left.mas_equalTo(classLb.mas_right).mas_equalTo(0);
        make.height.mas_equalTo(normalH);
        make.right.mas_equalTo(0);
    }];
    
    self.publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [_publishBtn setBackgroundColor:JYGlobalBg];
    [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishView addSubview:_publishBtn];
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(classLb.mas_bottom).mas_equalTo(margin);
        make.left.mas_equalTo(margin);
        make.right.bottom.mas_equalTo(-margin);
    }];
}

- (void)keyboardShow: (NSNotification *)notification{
    if (self.priceTF.editing || self.originPriceTF.editing || self.classTF.editing) {
        NSDictionary *dic = notification.userInfo;
        CGRect frame = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat moveHeight = -(self.publishBtn.origin.y+self.publishBtn.size.height)+frame.origin.y + margin;
        JYLog(@"%f",moveHeight);
        NSTimeInterval duration = [dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationOptions options = [dic[UIKeyboardAnimationCurveUserInfoKey] intValue];
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, moveHeight) animated:YES];
        } completion:nil];
    }
}

- (void)keyboardHide:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    NSTimeInterval duration = [dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [dic[UIKeyboardAnimationCurveUserInfoKey] intValue];
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    } completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark *** UITextViewDelegate ***

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"描述一下您的物品..."]) {
        textView.text = @"";
    }
    self.descTV.textColor = [UIColor darkTextColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if (self.descTV.text.length == 0) {
        self.descTV.text = @"描述一下您的物品...";
        self.descTV.textColor = [UIColor lightGrayColor];
    }
}

@end
