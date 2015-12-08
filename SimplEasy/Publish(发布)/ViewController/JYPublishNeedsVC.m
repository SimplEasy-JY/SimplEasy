//
//  JYPublishNeedsVC.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/7.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPublishNeedsVC.h"

static const CGFloat MARGIN = 10;
static const CGFloat NORMAL_H = 45;
static const CGFloat SECOND_ROW_H = 174;
static const CGFloat BTN_W = 45;
static const NSUInteger LIMIT_DESC_NUM = 20;
static NSString *DESC_PLACEHOLDER = @"描述一下您的需求...(限20字)";
@interface JYPublishNeedsVC () <UITextViewDelegate>

/** 急需 按钮 */
@property (nonatomic, strong) UIButton *JXBtn;
/** 求购 按钮 */
@property (nonatomic, strong) UIButton *QGBtn;
/** 需求 文本视图 */
@property (nonatomic, strong) UITextView *descTV;
@end

@implementation JYPublishNeedsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    JYLog(@"\n\n******************** 进入 发布需求 界面 ********************\n\n");
    self.view.backgroundColor = kRGBColor(236, 236, 236);
    [self configViews];
}

/** 配置第一行的界面 */
- (void)configViews{
    UIView *firstRowView = [[UIView alloc] init];
    firstRowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstRowView];
    [firstRowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(NORMAL_H);
    }];
    
    UIView *secondRowView = [UIView new];
    secondRowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondRowView];
    [secondRowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(firstRowView.mas_bottom).mas_equalTo(2);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SECOND_ROW_H);
    }];
    
    UILabel *publishLb = [[UILabel alloc] init];
    publishLb.text = @"发布";
    [firstRowView addSubview:publishLb];
    [publishLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MARGIN);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(BTN_W);
    }];
    
    
    UIButton *JXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.JXBtn = JXBtn;
    JXBtn.selected = YES;
    [JXBtn setTitle:@"急需" forState:UIControlStateNormal];
    [JXBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [JXBtn setTitleColor:JYGlobalBg forState:UIControlStateSelected];
    [JXBtn bk_addEventHandler:^(UIButton *sender) {
        sender.selected = YES;
        _QGBtn.selected = NO;
    } forControlEvents:UIControlEventTouchUpInside];
    
    [firstRowView addSubview:JXBtn];
    [JXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).mas_equalTo(-MARGIN);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(BTN_W);
    }];
    
    UIButton *QGBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.QGBtn = QGBtn;
    [QGBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [QGBtn setTitleColor:JYGlobalBg forState:UIControlStateSelected];
    [QGBtn setTitle:@"求购" forState:UIControlStateNormal];
    [QGBtn bk_addEventHandler:^(UIButton *sender) {
        sender.selected = YES;
        _JXBtn.selected = NO;
    } forControlEvents:UIControlEventTouchUpInside];
    [firstRowView addSubview:QGBtn];
    [QGBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).mas_equalTo(MARGIN);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(BTN_W);
    }];
    
    //需求内容
    UITextView *descTV = [[UITextView alloc] init];
    self.descTV = descTV;
    descTV.font = [UIFont systemFontOfSize:14];
    descTV.delegate = self;
    descTV.text = DESC_PLACEHOLDER;
    descTV.textColor = [UIColor lightGrayColor];
    [secondRowView addSubview:descTV];
    [descTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MARGIN, 0, NORMAL_H, MARGIN));
    }];
    
    //为TExtView加一个手势，左滑回收键盘
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [_descTV resignFirstResponder];
    }];
    swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [_descTV addGestureRecognizer:swipeGR];
    
    //定位学校
    UILabel *locationLb = [UILabel new];
    locationLb.text = @"浙江传媒学院";
    locationLb.font = [UIFont systemFontOfSize:12];
    locationLb.textColor = [UIColor darkGrayColor];
    [secondRowView addSubview:locationLb];
    [locationLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.height.mas_equalTo(NORMAL_H);
        make.bottom.mas_equalTo(0);
    }];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_07"]];
    locationImg.contentMode = UIViewContentModeScaleAspectFit;
    [secondRowView addSubview:locationImg];
    [locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MARGIN);
        make.centerY.mas_equalTo(locationLb);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    //发布按钮
    UIView *publishView = [UIView new];
    publishView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:publishView];
    [publishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(NORMAL_H+MARGIN);
    }];
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:JYGlobalBg];
    [publishView addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN));
    }];
}

#pragma mark *** UITextViewDelegate ***

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length>LIMIT_DESC_NUM) {
        textView.text = [textView.text substringToIndex:LIMIT_DESC_NUM];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:DESC_PLACEHOLDER]) {
        textView.text = @"";
    }
    self.descTV.textColor = [UIColor darkTextColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    if (self.descTV.text.length == 0) {
        self.descTV.text = DESC_PLACEHOLDER;
        self.descTV.textColor = [UIColor lightGrayColor];
    }
}
@end
