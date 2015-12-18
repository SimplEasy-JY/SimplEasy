//
//  JYPublishNeedsVC.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/7.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPublishNeedsVC.h"
#import "JYUserInfoNetManager.h"
#import "JYNormalModel.h"

static const CGFloat MARGIN = 10;
static const CGFloat NORMAL_H = 45;
static const CGFloat SECOND_ROW_H = 174;
static const CGFloat BTN_W = 45;
static const NSUInteger LIMIT_DESC_NUM = 20;
static NSString *DESC_PLACEHOLDER = @"描述一下您的需求...(限20字)";


#define JYSetUserName(string,dic)       [dic setObject:string forKey:@"username"]
#define JYSetPassword(string,dic)       [dic setObject:string forKey:@"password"]
#define JYSetDetail(string, dic)        [dic setObject:string forKey:@"detail"]
#define JYSetPrice(string, dic)         [dic setObject:string forKey:@"price"]

@interface JYPublishNeedsVC () <UITextViewDelegate>

/** 急需 按钮 */
@property (nonatomic, strong) UIButton *JXBtn;
/** 求购 按钮 */
@property (nonatomic, strong) UIButton *QGBtn;
/** 需求 文本视图 */
@property (nonatomic, strong) UITextView *descTV;
/** 价格TF */
@property (nonatomic, strong) UITextField *priceTF;
@end

@implementation JYPublishNeedsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    JYLog(@"\n\n******************** 进入 发布需求 界面 ********************\n\n");
    self.view.backgroundColor = kRGBColor(236, 236, 236);
    [JYFactory addBackItemToVC:self];
    [self configViews];
}

/** 配置界面 */
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
    [publishBtn addTarget:self action:@selector(publishNeeds:) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN));
    }];
    
    UIView *thirdView = [UIView new];
    thirdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:thirdView];
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(secondRowView.mas_bottom).mas_equalTo(1);
        make.height.mas_equalTo(NORMAL_H);
    }];
    
    UILabel *priceLb = [UILabel new];
    [thirdView addSubview:priceLb];
    priceLb.text = @"你的心里价位是？";
    priceLb.font = [UIFont systemFontOfSize:14];
    priceLb.textColor = [UIColor darkGrayColor];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MARGIN);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(NORMAL_H);
        make.width.mas_equalTo(kWindowW/2 - MARGIN);
    }];
    
    self.priceTF = [[UITextField alloc] init];
    _priceTF.placeholder = @"¥0.0";
    _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    [thirdView addSubview:_priceTF];
    [_priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLb.mas_right).mas_equalTo(0);
        make.height.mas_equalTo(NORMAL_H);
        make.centerY.mas_equalTo(priceLb);
        make.right.mas_equalTo(-MARGIN);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/** 判断输入的价格是否合法 */
- (BOOL)isLegalPrice: (NSString *)price{
    NSString *regex = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:price];
}
/** 发布需求 */
- (void)publishNeeds: (UIButton *)sender{
    if ([self.descTV.text isEqualToString:DESC_PLACEHOLDER]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入需求内容" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.descTV becomeFirstResponder];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (![self isLegalPrice:self.priceTF.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"价格不对哦！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.priceTF becomeFirstResponder];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JYUserInfoNetManager publishNeedsWithParams:[self params] completionHandle:^(JYNormalModel *model, NSError *error) {
        if (model.status.integerValue == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:model.errorMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }];
    
}

- (NSDictionary *)params{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *tel = [[NSUserDefaults standardUserDefaults] objectForKey:IMLoginTEL];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:IMLoginPassword];
    JYSetUserName(tel, params);
    [params setObject:@"18768102901" forKey:@"tel"];
    JYSetPassword(password, params);
    JYSetDetail(self.descTV.text, params);
    JYSetPrice(self.descTV.text, params);
    return [params copy];
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
