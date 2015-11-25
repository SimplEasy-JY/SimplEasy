//
//  JYRegisterViewController.m
//  SimplEasy
//
//  Created by 杨胜浩 on 15/11/25.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYRegisterViewController.h"
#import "IMDefine.h"
#import "UIView+IM.h"
#import "JYRootViewController.h"
#import "UIImage+Circle.h"
#import "JYRegisterViewController.h"
#import "JYUserProtocolViewController.h"

//third-party
#import "SFCountdownView.h"
#import "BDKNotifyHUD.h"
#import <SMS_SDK/SMSSDK.h>

//IMSDK Header
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMLoginView.h"
#import "IMSDK+CustomUserInfo.h"

static CGFloat textFieldH = 44;
static CGFloat leftTextFieldH = 44;
static CGFloat leftTextFieldW = 105;
static CGFloat bottomLR = 63;
static CGFloat bottomLabelW = 122;
static CGFloat bottomLabelH = 18;
static CGFloat bottomButtomW = 67;


@interface JYRegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(strong,nonatomic)TPKeyboardAvoidingTableView *tableView;
@property(strong,nonatomic)UITextField *userField;
@property(strong,nonatomic)UITextField *passField;
@property(strong,nonatomic)UITextField *confirmPassField;
@property(strong,nonatomic)UITextField *phoneNumField;
@property(strong,nonatomic)UITextField *testField;
@property(strong,nonatomic)UIButton *registerButton;
@property(strong,nonatomic)NSArray *textFieldArr;

//倒计时
@property(assign,nonatomic)NSInteger totalTime;
@property(strong,nonatomic)UILabel *rightLabel;

//底部
@property(strong,nonatomic)UILabel *bottomLabel;
@property(strong,nonatomic)UIButton *bottomButton;

@end

@implementation JYRegisterViewController{
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}
-(TPKeyboardAvoidingTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[TPKeyboardAvoidingTableView  alloc]initWithFrame:CGRectMake(0, kWindowH/2-textFieldH*4, kWindowW, textFieldH*5)];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = JYWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSArray *)textFieldArr{
    if (!_textFieldArr) {
        self.textFieldArr = [[NSArray  alloc]initWithObjects:self.userField,self.passField,self.confirmPassField,self.phoneNumField,self.testField,nil];
    }
    return _textFieldArr;
}
-(UITextField *)userField{
    if (!_userField) {
        self.userField = [[UITextField  alloc]initWithFrame:CGRectMake(10, 0, kWindowW-10, textFieldH)];
        _userField.placeholder = @"请输入用户名";
        _userField.delegate = self;
    }
    return _userField;
}
-(UITextField *)passField{
    if (!_passField) {
        self.passField = [[UITextField  alloc]initWithFrame:CGRectMake(10, 0, kWindowW-10, textFieldH)];
        _passField.placeholder = @"请输入密码";
        _passField.delegate = self;
    }
    return _passField;
}
-(UITextField *)confirmPassField{
    if (!_confirmPassField) {
        self.confirmPassField = [[UITextField  alloc]initWithFrame:CGRectMake(10, 0, kWindowW-10, textFieldH)];
        _confirmPassField.placeholder = @"请确认密码";
        _confirmPassField.delegate = self;
    }
    return _confirmPassField;
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
-(UIButton *)registerButton{
    if (!_registerButton) {
        self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(30, kWindowH/2+textFieldH+10, kWindowW-60, textFieldH);
        _registerButton.backgroundColor = JYHexColor(0x263554);
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
//        _loginButton.tag = 100;
        [_registerButton.layer setCornerRadius:4.0];
    }
    return _registerButton;
}
-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        self.bottomLabel = [[UILabel  alloc]initWithFrame:CGRectMake(bottomLR, kWindowH-bottomLabelH-20, bottomLabelW, bottomLabelH)];
        _bottomLabel.text = @"点击注册表示同意";
        _bottomLabel.font = [UIFont systemFontOfSize:15];
        _bottomLabel.textColor = kRGBColor(108, 106, 105);
    }
    return _bottomLabel;
}
-(UIButton *)bottomButton{
    if (!_bottomButton) {
        self.bottomButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(bottomLR+bottomLabelW, kWindowH-bottomLabelH-20, bottomButtomW, bottomLabelH);
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"用户协议"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [_bottomButton setAttributedTitle:title
                          forState:UIControlStateNormal];
        [_bottomButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _bottomButton;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bottomButton bk_addEventHandler:^(id sender) {
        JYUserProtocolViewController *vc = [[JYUserProtocolViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //取消按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 15, 40, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:JYHexColor(0x49e046) forState:UIControlStateNormal];
        [button setTitleColor:kRGBColor(200, 200, 200) forState:UIControlStateHighlighted];
        [button bk_addEventHandler:^(id sender) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        

        self.view.backgroundColor = kRGBColor(239, 239, 239);
        [self.view addSubview:button];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.registerButton];
        [self.view addSubview:self.bottomLabel];
        [self.view addSubview:self.bottomButton];
        
    }
    return self;
}
#pragma mark - 响应方法
-(void)getSmsCode:(UIButton *)sender{
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
                self.totalTime = 10;
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
-(void)registerClick:(UIButton *)sender{
    [[self view] endEditing:YES];
    
    NSString *customUserID = self.userField.text;
    NSString *password = self.passField.text;
    NSString *confirmPassword = self.confirmPassField.text;
    NSString *testNumb = self.phoneNumField.text;
    
    if (customUserID.length > 0) {
        if (password.length == 0 || confirmPassword.length == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        if (![password isEqualToString:confirmPassword]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入的密码不一致，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
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
                [self presentViewController:alert animated:YES completion:nil];
            }else {
                [g_pIMMyself setCustomUserID:customUserID];
                [g_pIMMyself setPassword:password];
                [g_pIMMyself registerWithTimeoutInterval:5 success:^{
                    JYRootViewController *controller = [[JYRootViewController alloc] init];
                    [self addChildViewController:controller];
                    [[self view] addSubview:controller.view];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
                    [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
                    [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //应用角标清零
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    
                    [_passField setText:nil];
                    [[self view] endEditing:YES];
                } failure:^(NSString *error) {
                    if ([error isEqualToString:@"customUserID只能由2 ～32位字母、数字、下划线、点或@符组成"]) {
                        error = @"账号只能由2 ～32位字母、数字、下划线、点或@符组成";
                    }
                    if ([error isEqualToString:@"Wrong Password"]) {
                        error = @"密码错误,请重新输入";
                    } else if ([error isEqualToString:@"customUserID should be only built by letters, Numbers, underscores, or '@''.',and the length between 2 to 32 characters"]){
                        error = @"用户名只能由字母、数字、下划线、@符或点组成,长度不能超过32位，也不能少于2位";
                    } else if ([error isEqualToString:@"Password length should between 2 to 32 characters"]) {
                        error = @"密码长度不能超过32位，也不能少于2位";
                    } else if ([error isEqualToString:@"password不能为空字符串"] || [error isEqualToString:@"password不能为nil"]) {
                        error = @"密码不能为空";
                    } else if ([error isEqualToString:@"customUserID不能为null"] || [error isEqualToString:@"customUserID不能为空字符串"]){
                        error = @"账号不能为空";
                    } else if ([error isEqualToString:@"Time out"]) {
                        error = @"登录超时";
                    } else if ([error isEqualToString:@"CustomUserID Already Exist"]) {
                        error = @"用户已经存在";
                    } else if ([error isEqualToString:@"CustomUserID is not exist"]) {
                        error = @"用户不存在";
                    } else if ([error isEqualToString:@"The passwords input twice are inconsistent"]) {
                        error = @"两次输入密码不一致";
                    } else {
                        if (!error) {
                            error = @"登录失败";
                        }
                    }
                    [self performSelector:@selector(loginError:) withObject:error afterDelay:0.5];
                }];
            }
        }];
            } else {
        _notifyText = @"请输入用户名";
        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
        [self displayNotifyHUD];
    }



}
- (void)loginError:(NSString *)error {
    
    _notifyText = error;
    _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
    [self displayNotifyHUD];
    
    
}
/**  点击空白回收键盘 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

kRemoveCellSeparator

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell addSubview:self.textFieldArr[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}


#pragma mark - textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.userField) {
    }else if (textField == self.passField){
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userField) {
        [self.passField becomeFirstResponder];
        return NO;
    } else if (textField == self.passField) {
        [self.confirmPassField becomeFirstResponder];
        return NO;
    }else {
        [[self view] endEditing:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.userField) {
        if ([[textField text] length] + [string length] > 32 ) {
            _notifyText = @"用户名不能超过32个字符";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return NO;
        }
        
//        NSMutableString *customUserID = [[NSMutableString alloc] initWithFormat:@"%@",[textField text]];
//        
//        [customUserID replaceCharactersInRange:range withString:string];
//        
//        UIImage *image = [g_pIMSDK mainPhotoOfUser:customUserID];
//        
//        if (image) {
//            [_headView setImage:image];
//        } else {
//            NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:customUserID];
//            
//            NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
//            NSString *sex = nil;
//            
//            if ([customInfoArray count] > 0) {
//                sex = [customInfoArray objectAtIndex:0];
//            }
//            
//            if ([sex isEqualToString:@"女"]) {
//                [_headView setImage:[UIImage imageNamed:@"IM_head_female.png"]];
//            } else {
//                [_headView setImage:[UIImage imageNamed:@"IM_head_male.png"]];
//            }
//            
//        }
//    }
    }
    
    if (textField == _passField) {
        if ([[textField text] length] + [string length] > 32 ) {
            _notifyText = @"密码不能超过32个字符";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return NO;
        }
    }
    return YES;
}

#pragma mark - notify hud

- (BDKNotifyHUD *)notify {
    if (_notify != nil){
        return _notify;
    }
    
    _notify = [BDKNotifyHUD notifyHUDWithImage:_notifyImage text:_notifyText];
    [_notify setCenter:CGPointMake(self.view.center.x, self.view.center.y - 20)];
    return _notify;
}

- (void)displayNotifyHUD {
    if (_notify) {
        [_notify removeFromSuperview];
        _notify = nil;
    }
    
    [self.view addSubview:[self notify]];
    [[self notify] presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [[self notify] removeFromSuperview];
    }];
}


@end
