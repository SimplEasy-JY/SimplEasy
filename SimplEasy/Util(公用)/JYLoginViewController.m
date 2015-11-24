//
//  IMLoginViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "JYLoginViewController.h"
#import "IMDefine.h"
#import "UIView+IM.h"
#import "JYRootViewController.h"
#import "JYLoginView.h"
#import "UIImage+Circle.h"

//third-party
#import "SFCountdownView.h"
#import "BDKNotifyHUD.h"

//IMSDK Header
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMLoginView.h"
#import "IMSDK+CustomUserInfo.h"

@interface JYLoginViewController ()<UITableViewDataSource, UITableViewDelegate ,UITextFieldDelegate, IMLoginViewDelegate>

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITextField *userNameField;
@property(strong,nonatomic)UITextField *passwordField;
@property(strong,nonatomic)UIButton *loginButton;
@property(strong,nonatomic)UIImageView *userImageView;
@end

@implementation JYLoginViewController {
//    UITableView *_tableview;
//    UITextField *_userNameField;
//    UITextField *_passwordField;
//    UIButton *_loginBtn;
    UIImageView *_backgroundView;
    UIView *_backHeadView;
    UIImageView *_headView;
    double _angle;
    BOOL _isStop;
    
//    IMLoginView *_loginView;
    
    //third-party
    SFCountdownView *_countdownView;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}
#pragma mark - 懒加载
-(UIImageView *)userImageView{
    if (!_userImageView) {
        self.userImageView = [[UIImageView  alloc]initWithImage:[UIImage circleImageWithName:@"logo" borderWidth:0.5 borderColor:JYWhite]];
        _userImageView.frame = CGRectMake(kWindowW/2-40, 50, 80, 80);
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}
-(UIButton *)loginButton{
    if (!_loginButton) {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(30, 245, kWindowW-60, 44);
        _loginButton.backgroundColor = kRGBColor(39, 43, 52);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
//        _loginButton.titleLabel.textColor = JYWhite;
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.tag = 100;
        [_loginButton.layer setCornerRadius:4.0];
        
    }
    return _loginButton;
}
-(UITextField *)passwordField{
    if (!_passwordField) {
        self.passwordField = [[UITextField  alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 44)];
        _passwordField.delegate = self;
        _passwordField.backgroundColor = kRGBColor(250, 250, 250);
        //密码模式
        _passwordField.secureTextEntry = YES;
        _passwordField.placeholder = @"密码";
        _passwordField.textAlignment = NSTextAlignmentCenter;
    }
    return _passwordField;
}
-(UITextField *)userNameField{
    if (!_userNameField) {
        self.userNameField = [[UITextField  alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 44)];
        _userNameField.delegate = self;
        _userNameField.backgroundColor = kRGBColor(250, 250, 250);
        _userNameField.placeholder = @"简易号/手机号/QQ号";
        _userNameField.textAlignment = NSTextAlignmentCenter;
        //自适应
        _userNameField.adjustsFontSizeToFitWidth = YES;
        _userNameField.clearsOnBeginEditing = YES;
        _userNameField.clearButtonMode = UITextFieldViewModeAlways;
        UIImage *image = [UIImage imageNamed:@"arrowDown"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [rightButton setImage:image forState:UIControlStateNormal];
        _userNameField.rightView = rightButton;
        _userNameField.rightViewMode = UITextFieldViewModeAlways;

    }
    return _userNameField;
}
-(UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 140, kWindowW, 90)];
        _tableView.backgroundColor = JYWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.view.backgroundColor = kRGBColor(239, 239, 239);
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.loginButton];
        [self.view addSubview:self.userImageView];
    
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

    
    /**  跳过注册按钮、  实际是采用自动注册 */
//    UIButton *button = [[UIButton alloc]init];

//    button.backgroundColor = [UIColor blackColor];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(_loginView).width.insets(UIEdgeInsetsMake(70, kWindowW-10-100, kWindowH-70-50, 10));
//    }];
//    [button bk_addEventHandler:^(id sender) {
//        [g_pIMMyself autoRegisterWithTimeoutInterval:5 success:^(NSString *customUserID, NSString *password) {
//            JYRootViewController *controller = [[JYRootViewController alloc] init];
//            
//            [self addChildViewController:controller];
//            [[self view] addSubview:controller.view];
//        } failure:^(NSString *error) {
//            NSLog(@"注册失败");
//        }];
//       
//
//    } forControlEvents:UIControlEventTouchUpInside];
    

    
    if ([g_pIMMyself loginStatus] != IMMyselfLoginStatusNone) {
        JYRootViewController *controller = [[JYRootViewController alloc] init];
        
        [self addChildViewController:controller];
        [[self view] addSubview:controller.view];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:IMLogoutNotification object:nil];
    
}



    



//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
////    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
////    
////    NSMutableString *customUserID = [[NSMutableString alloc] initWithFormat:@"%@",[_userNameField text]];
////    
////    UIImage *image = [g_pIMSDK mainPhotoOfUser:customUserID];
////    
////    if (image) {
////        [_headView setImage:image];
////    } else {
////        [_headView setImage:[UIImage imageNamed:@"IM_head_default.png"]];
////    }
////    [_loginView viewWillAppear];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -响应方法
- (void)login:(UIButton *)sender {
    _isStop = NO;
    if (sender != self.loginButton) {
        return;
    }
    [[self view] endEditing:YES];
    
    NSString *customUserID = self.userNameField.text;
    NSString *password = self.passwordField.text;
    
    if ([customUserID length] > 0) {
        if ([password length] == 0) {
            _notifyText = @"请输入密码";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            return;
        }
        //旋转logo
        if (sender.tag == 100) {
            [self startAnimation];
        }
        sender.tag +=1;
        //提交任务（同步）
        dispatch_sync(dispatch_queue_create("first", DISPATCH_QUEUE_CONCURRENT), ^{//同步执行
            [g_pIMMyself setCustomUserID:customUserID];
            [g_pIMMyself setPassword:password];
            [g_pIMMyself loginWithTimeoutInterval:5 success:^{
                _isStop = YES;
                JYRootViewController *controller = [[JYRootViewController alloc] init];
                
                [self addChildViewController:controller];
                [[self view] addSubview:controller.view];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
                [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
                [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //应用角标清零
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                [_countdownView removeFromSuperview];
                _countdownView = nil;
                [_passwordField setText:nil];
                [[self view] endEditing:YES];
            } failure:^(NSString *error) {
                NSLog(@"%@",error);
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
        });
        
        
//        [g_pIMMyself loginWithAutoRegister:YES timeoutInterval:10 success:^(BOOL autoLogin) {
//            JYRootViewController *controller = [[JYRootViewController alloc] init];
//            
//            [self addChildViewController:controller];
//            [[self view] addSubview:controller.view];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
//            [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
//            [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            //应用角标清零
//            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//            
//            [_countdownView removeFromSuperview];
//            _countdownView = nil;
//            
//            [_passwordField setText:nil];
//            [[self view] endEditing:YES];
//        } failure:^(NSString *error) {
//            if ([error isEqualToString:@"Wrong Password"]) {
//                error = @"密码错误,请重新输入";
//            } else if ([error isEqualToString:@"customUserID should be only built by letters, Numbers, underscores, or '@''.',and the length between 2 to 32 characters"]){
//                error = @"用户名只能由字母、数字、下划线、@符或点组成,长度不能超过32位，也不能少于2位";
//            } else if ([error isEqualToString:@"Password length should between 2 to 32 characters"]) {
//                error = @"密码长度不能超过32位，也不能少于2位";
//            } else {
//                error = @"请检查网络是否可用";
//            }
//            
//            [self performSelector:@selector(loginError:) withObject:error afterDelay:1.0];
//        }];
//        
//        _countdownView = [[SFCountdownView alloc] initWithFrame:[self view].bounds];
//        
//        [_countdownView setCountdownFrom:10];
//        [_countdownView start];
//        [[self view] addSubview:_countdownView];
//    } else {
//        _notifyText = @"请输入用户名";
//        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
//        [self displayNotifyHUD];
    }
}
//图标旋转方法
- (void)startAnimation{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.userImageView.transform = endAngle;
    } completion:^(BOOL finished) {
        _angle += 30;
        if (!_isStop) {
            [self startAnimation];
        }
      
    }];
    
}

- (void)logout {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    [_loginView viewWillAppear];
}

- (void)loginError:(NSString *)error {
    
    _notifyText = error;
    _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
    [self displayNotifyHUD];
    
    [_countdownView removeFromSuperview];
    _countdownView = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}


//#pragma mark - IMLoginView delegate
//
//- (void)loginViewDidLogin:(BOOL)autoLogin {
//    JYRootViewController *controller = [[JYRootViewController alloc] init];
//    
//    [self addChildViewController:controller];
//    [[self view] addSubview:controller.view];
//    NSLog(@"user:%@",_userNameField.text);
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
//    [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
//    [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    //应用角标清零
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    
//    [_countdownView removeFromSuperview];
//    _countdownView = nil;
//    
//}
//
//- (void)loginViewLoginFailedWithError:(NSString *)error {
//    if ([error isEqualToString:@"Wrong Password"]) {
//        error = @"密码错误,请重新输入";
//    } else if ([error isEqualToString:@"customUserID should be only built by letters, Numbers, underscores, or '@''.',and the length between 2 to 32 characters"]){
//        error = @"用户名只能由字母、数字、下划线、@符或点组成,长度不能超过32位，也不能少于2位";
//    } else if ([error isEqualToString:@"Password length should between 2 to 32 characters"]) {
//        error = @"密码长度不能超过32位，也不能少于2位";
//    } else if ([error isEqualToString:@"password不能为空字符串"] || [error isEqualToString:@"password不能为nil"]) {
//        error = @"密码不能为空";
//    } else if ([error isEqualToString:@"customUserID不能为null"] || [error isEqualToString:@"customUserID不能为空字符串"]){
//        error = @"账号不能为空";
//    } else if ([error isEqualToString:@"Time out"]) {
//        error = @"登录超时";
//    } else if ([error isEqualToString:@"CustomUserID Already Exist"]) {
//        error = @"用户已经存在";
//    } else if ([error isEqualToString:@"CustomUserID is not exist"]) {
//        error = @"用户不存在";
//    } else if ([error isEqualToString:@"The passwords input twice are inconsistent"]) {
//        error = @"两次输入密码不一致";
//    } else {
//        if (!error) {
//            error = @"登录失败";
//        }
//    }
//    
//    [self performSelector:@selector(loginError:) withObject:error afterDelay:0.5];
//}
//
//- (void)loginActionStarted {
//    _countdownView = [[SFCountdownView alloc] initWithFrame:[self view].bounds];
//
//    [_countdownView setCountdownFrom:10];
//    [_countdownView start];
//    [[self view] addSubview:_countdownView];
//}


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
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, kWindowW, 1)];
        lineView.backgroundColor = kRGBColor(239, 239, 239);
        [cell addSubview:lineView];
        [cell addSubview:self.userNameField];
        
    } else if (indexPath.row == 1) {
        [cell addSubview:self.passwordField];
    }
    
    [cell setBackgroundColor:RGB(223, 235, 240)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 45.f:44.f;
}


#pragma mark - textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.userNameField) {
        self.userImageView.transform = CGAffineTransformMakeRotation(0);
        self.loginButton.tag = 100;
        _isStop = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.userNameField) {
    }else if (textField == self.passwordField){
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameField) {
        [self.passwordField becomeFirstResponder];
        
        return NO;
    } else if (textField == self.passwordField) {
        [[self view] endEditing:YES];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.userNameField) {
        if ([[textField text] length] + [string length] > 32 ) {
            _notifyText = @"用户名不能超过32个字符";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return NO;
        }
        
        NSMutableString *customUserID = [[NSMutableString alloc] initWithFormat:@"%@",[textField text]];
        
        [customUserID replaceCharactersInRange:range withString:string];
        
         UIImage *image = [g_pIMSDK mainPhotoOfUser:customUserID];
        
        if (image) {
            [_headView setImage:image];
        } else {
            NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:customUserID];
            
            NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
            NSString *sex = nil;
            
            if ([customInfoArray count] > 0) {
                sex = [customInfoArray objectAtIndex:0];
            }
            
            if ([sex isEqualToString:@"女"]) {
                [_headView setImage:[UIImage imageNamed:@"IM_head_female.png"]];
            } else {
                [_headView setImage:[UIImage imageNamed:@"IM_head_male.png"]];
            }
        
        }
    }
    
    if (textField == _passwordField) {
        if ([[textField text] length] + [string length] > 32 ) {
            _notifyText = @"密码不能超过32个字符";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return NO;
        }
    }
    return YES;
}


//#pragma mark - keyboard notifications
//
//- (void)keyboardWillShow:(NSNotification *)notification {
//    if ([[self childViewControllers] count] > 0) {
//        return;
//    }
//    
//    NSDictionary *userInfo = [notification userInfo];
//    
//    // Get the origin of the keyboard when it's displayed.
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
//    CGRect keyboardRect = [aValue CGRectValue];
//    [self.view convertRect:keyboardRect fromView:nil];
//    
//    // Get the duration of the animation.
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    CGRect frame = self.view.frame;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    frame.origin.y =  -80;
//    if ([UIScreen mainScreen].bounds.size.height == 480) {
//        frame.origin.y = -100;
//    }
//    self.view.frame = frame;
//    [UIView commitAnimations];
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    if ([[self childViewControllers] count] > 0) {
//        return;
//    }
//    
//    NSDictionary *userInfo = [notification userInfo];
//    
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    [[self view] convertRect:keyboardRect fromView:nil];
//    
//    // Get the duration of the animation.
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    CGRect frame = self.view.frame;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//    frame.origin.y = 0;
//#elif __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
//    frame.origin.y = 20;
//#endif
//    self.view.frame = frame;
//    [UIView commitAnimations];
//}


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
