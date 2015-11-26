//
//  JYPhoneNumViewController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/25.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPhoneNumViewController.h"
#import "JYRegisterViewController.h"
#import "JYUserProtocolViewController.h"


#import <SMS_SDK/SMSSDK.h>

static CGFloat textFieldH = 44;
static CGFloat leftTextFieldH = 44;
static CGFloat leftTextFieldW = 105;
static CGFloat bottomLR = 64;
static CGFloat bottomLabelW = 135;
static CGFloat bottomLabelH = 18;
static CGFloat bottomButtomW = 67;
static CGFloat space = 30;


@interface JYPhoneNumViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITextField *phoneNumField;
@property(strong,nonatomic)UITextField *testField;
@property(strong,nonatomic)UILabel *bottomLabel;
@property(strong,nonatomic)UIButton *bottomButton;
@property(strong,nonatomic)UIButton *nextButton;
@property(strong,nonatomic)UILabel *rightLabel;
@property(assign,nonatomic)NSInteger totalTime;

@end

@implementation JYPhoneNumViewController

-(UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, kWindowH/2-textFieldH*4, kWindowW, textFieldH*2)];
        _tableView.backgroundColor = JYWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(UITextField *)phoneNumField{
    if (!_phoneNumField) {
        self.phoneNumField = [[UITextField  alloc]initWithFrame:CGRectMake(0, 0, kWindowW, textFieldH)];
        _phoneNumField.placeholder = @"请输入手机号";
        _phoneNumField.delegate = self;
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, leftTextFieldW , leftTextFieldH)];
        leftLabel.text = @"   中国 +86";
        leftLabel.textColor = JYGlobalBg;
        _phoneNumField.leftView = leftLabel;
        _phoneNumField.leftViewMode = UITextFieldViewModeAlways;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(leftTextFieldW-1, 0, 1, leftTextFieldH)];
        view.backgroundColor = JYLineColor;
        [_phoneNumField addSubview:view];
        
    }
    return _phoneNumField;
}
-(UITextField *)testField{
    if (!_testField) {
        self.testField = [[UITextField  alloc]initWithFrame:CGRectMake(0, 0, kWindowW, textFieldH)];
        _testField.delegate = self;
        //右边按钮
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, leftTextFieldW , leftTextFieldH)];
        [leftButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [leftButton setTitleColor:JYWhite forState:UIControlStateNormal];
        [leftButton setTitleColor:kRGBColor(146, 146, 146) forState:UIControlStateSelected];
        [leftButton setBackgroundImage:[UIImage imageWithColor:JYGlobalBg cornerRadius:0] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageWithColor:JYLineColor cornerRadius:0] forState:UIControlStateSelected];
        [leftButton addTarget:self action:@selector(getSmsCode:) forControlEvents:UIControlEventTouchUpInside];
        _testField.leftView = leftButton;
        _testField.leftViewMode = UITextFieldViewModeAlways;
        //左边倒计时
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, leftTextFieldW/2, leftTextFieldH)];
        self.rightLabel.textColor = JYLineColor;
        _testField.rightView = self.rightLabel;
        _testField.rightViewMode = UITextFieldViewModeAlways;
        _testField.rightView.hidden = YES;
    }
    return _testField;
}
-(UIButton *)nextButton{
    if (!_nextButton) {
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(space, kWindowH/2-textFieldH*2+15, kWindowW-space*2, textFieldH);
        _nextButton.backgroundColor = JYButtonColor;
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    return _nextButton;
}
-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        self.bottomLabel = [[UILabel  alloc]initWithFrame:CGRectMake(bottomLR, kWindowH-bottomLabelH-20-bottomLR, bottomLabelW, bottomLabelH)];
        _bottomLabel.text = @"点击下一步表示同意";
        _bottomLabel.font = [UIFont systemFontOfSize:15];
        _bottomLabel.textColor = kRGBColor(108, 106, 105);
    }
    return _bottomLabel;
}
-(UIButton *)bottomButton{
    
    if (!_bottomButton) {
        self.bottomButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(bottomLR+bottomLabelW, kWindowH-bottomLabelH-20-bottomLR, bottomButtomW, bottomLabelH);
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"用户协议"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [_bottomButton setAttributedTitle:title
                                 forState:UIControlStateNormal];
        [_bottomButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _bottomButton;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = kRGBColor(239, 239, 239);
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.nextButton];
        [self.view addSubview:self.bottomLabel];
        [self.view addSubview:self.bottomButton];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机验证";
    //设置不能滚动
    self.tableView.scrollEnabled = NO;
    [self.bottomButton bk_addEventHandler:^(id sender) {
        JYUserProtocolViewController *vc = [[JYUserProtocolViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];

}
-(void)viewWillAppear:(BOOL)animated{
    //显示导航栏
    self.navigationController.navigationBarHidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -响应方法
-(void)nextClick:(UIButton *)sender{
     NSString *testNumb = self.testField.text;
    if (testNumb.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.phoneNumField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [SMSSDK commitVerificationCode:testNumb phoneNumber:self.phoneNumField.text zone:@"86" result:^(NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
             [self.navigationController pushViewController:[[JYRegisterViewController alloc]init] animated:YES];
            [self presentViewController:alert animated:YES completion:nil];
           
        }else {
            JYRegisterViewController *vc =  [[JYRegisterViewController alloc]init];
            vc.phoneNum = self.phoneNumField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}
-(void)getSmsCode:(UIButton *)sender{
    if (self.phoneNumField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //zone 国家代码  86 代表中国
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码发送失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            //锁定按钮状态
            if (sender.selected) {
                return ;
            }
            sender.selected = YES;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码发送成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            self.testField.rightView.hidden = NO;
            dispatch_queue_t queue = dispatch_queue_create("countQueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            
            dispatch_async(queue, ^{
                self.totalTime = 60;
                while (self.totalTime > 0) {
                    [NSThread sleepForTimeInterval:1];
                    self.totalTime -- ;
                    NSString *timeStr = [NSString stringWithFormat:@"(%lds)",self.totalTime];
                    dispatch_async(mainQueue, ^{
                        self.rightLabel.text = timeStr;
                    });
                }
                //解锁按钮状态
                dispatch_async(mainQueue, ^{//主线程刷新UI
                    sender.selected = NO;
                });
                self.rightLabel.hidden = YES;
            });
        }
    }];
    
}


kRemoveCellSeparator

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row == 0) {
        [cell addSubview:self.phoneNumField];
    }else {
        [cell addSubview:self.testField];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}


#pragma mark - textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[self view] endEditing:YES];
    return YES;
}
@end
