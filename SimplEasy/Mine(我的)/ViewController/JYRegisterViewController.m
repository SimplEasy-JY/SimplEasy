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
#import "JYRootViewController.h"
#import "JYPhoneNumViewController.h"
#import "JYLoginRegisterModel.h"
#import "JYLoginManager.h"

//third-party
#import "SFCountdownView.h"
#import "BDKNotifyHUD.h"


//IMSDK Header
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMLoginView.h"
#import "IMSDK+CustomUserInfo.h"

static CGFloat textFieldH = 44;
static CGFloat space = 30;


@interface JYRegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(strong,nonatomic)TPKeyboardAvoidingTableView *tableView;
@property(strong,nonatomic)UITextField *userField;
@property(strong,nonatomic)UITextField *passField;
@property(strong,nonatomic)UITextField *confirmPassField;
@property(strong,nonatomic)UIButton *registerButton;
@property(strong,nonatomic)NSArray *textFieldArr;


@end

@implementation JYRegisterViewController{
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}
-(TPKeyboardAvoidingTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[TPKeyboardAvoidingTableView  alloc]initWithFrame:CGRectMake(0, kWindowH/2-textFieldH*3.5, kWindowW, textFieldH*3)];
        _tableView.backgroundColor = JYWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSArray *)textFieldArr{
    if (!_textFieldArr) {
        self.textFieldArr = [[NSArray  alloc]initWithObjects:self.userField,self.passField,self.confirmPassField,nil];
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


-(UIButton *)registerButton{
    if (!_registerButton) {
        self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(space, kWindowH/2+15+textFieldH, kWindowW-space*2, textFieldH);
        _registerButton.backgroundColor = JYButtonColor;
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
//        _loginButton.tag = 100;
        [_registerButton.layer setCornerRadius:4.0];
    }
    return _registerButton;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //上一步按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 25, 60, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:@"上一步" forState:UIControlStateNormal];
    [button setTitleColor:JYGlobalBg forState:UIControlStateNormal];
    [button setTitleColor:kRGBColor(200, 200, 200) forState:UIControlStateHighlighted];
    [button bk_addEventHandler:^(id sender) {
//        [self dismissViewControllerAnimated:YES completion:nil];
        JYPhoneNumViewController *vc = [[JYPhoneNumViewController alloc]init];
        [rootVC addChildViewController:vc];
        [rootVC.view addSubview:vc.view];
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//    [loginVC addObserver:rootVC forKeyPath:@"isLogin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = kRGBColor(239, 239, 239);
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.registerButton];
        
    }
    return self;
}
/**  点击空白回收键盘 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}
#pragma mark - 响应方法
-(void)registerClick:(UIButton *)sender{
    [[self view] endEditing:YES];
    
    NSString *customUserID = self.userField.text;
    NSString *password = self.passField.text;
    NSString *confirmPassword = self.confirmPassField.text;
  
    
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
        else {
            JYLog(@"+++++++++++++++%@ phonenum",self.phoneNum);
            NSDictionary *parms = @{@"tel":self.phoneNum,@"password":password,@"name":customUserID};
            [JYLoginManager loginOrRegisterWith:parms Login:NO completionHandle:^(JYLoginRegisterModel *model, NSError *error) {
                if (model.error_msg ) {
                    _notifyText = model.error_msg;
                    _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
                    [self displayNotifyHUD];
                    return ;
                }
                [g_pIMMyself setCustomUserID:customUserID];
                [g_pIMMyself setPassword:password];
                [g_pIMMyself registerWithTimeoutInterval:5 success:^{
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
                    [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
                    [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //应用角标清零
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    [_passField setText:nil];
                    [[self view] endEditing:YES];
                    [self removeFromParentViewController];
                    [[self view] removeFromSuperview];
                    rootVC.tabBarController.selectedIndex = 0;
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
            }];
            }
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

kRemoveCellSeparator

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
