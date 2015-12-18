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
#import "UIImage+Circle.h"
#import "JYPhoneNumViewController.h"
#import "JYLoginManager.h"
#import "JYLoginRegisterModel.h"

//third-party
#import "SFCountdownView.h"
#import "BDKNotifyHUD.h"

//IMSDK Header
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMLoginView.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMMyself+CustomUserInfo.h"

static CGFloat bottomBtnH = 30;
static CGFloat bottomBtnW = 80;
static CGFloat tabviewH = 88;
static CGFloat imgviewH = 80;
static CGFloat textFieldH = 44;

static JYLoginViewController *loginViewC = nil;// 定义全局静态变量

@interface JYLoginViewController ()<UITableViewDataSource, UITableViewDelegate ,UITextFieldDelegate,IMLoginViewDelegate>

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITextField *userNameField;
@property(strong,nonatomic)UITextField *passwordField;
@property(strong,nonatomic)UIButton *loginButton;
@property(strong,nonatomic)UIImageView *userImageView;
@property(strong,nonatomic)UIButton *registerButton;
@property(strong,nonatomic)UIButton *touristButton;
@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *password;
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
//    SFCountdownView *_countdownView;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (!loginViewC) {
        loginViewC = [super allocWithZone:zone];//如果没有实例让父类去创建一个
        return loginViewC;
    }
    return nil;
}
+ (JYLoginViewController *)shareLoginVC  //定义一个类方法进行访问(便利构造)
{
    if (!loginViewC) {
        loginViewC = [[JYLoginViewController alloc]init];// 如果实例不存在进行创建
    }
    return loginViewC;
    
}

// 封堵深复制 （copy 和 mutablecopy 都可以实现深复制 但他们最终都需要调用copyWithZone方法所以直接封堵它）
- (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}


#pragma mark - 懒加载
-(UIButton *)touristButton{
    if (!_touristButton) {
        self.touristButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        _touristButton.frame = CGRectMake(0, kWindowH-bottomBtnH, bottomBtnW, bottomBtnH);
        _touristButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_touristButton setTitle:@"游客登录" forState:UIControlStateNormal];
        [_touristButton setTitleColor:JYHexColor(0x49e046) forState:UIControlStateNormal];
        [_touristButton setTitleColor:kRGBColor(200, 200, 200) forState:UIControlStateHighlighted];
    }
    return _touristButton;
}
-(UIButton *)registerButton{
    if (!_registerButton) {
        self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(kWindowW-bottomBtnW, kWindowH-bottomBtnH, bottomBtnW, bottomBtnH);
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerButton setTitle:@"新用户注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:JYHexColor(0x49e046) forState:UIControlStateNormal];
        [_registerButton setTitleColor:kRGBColor(200, 200, 200) forState:UIControlStateHighlighted];
    }
    return _registerButton;
}
-(UIImageView *)userImageView{
    if (!_userImageView) {
        self.userImageView = [[UIImageView  alloc]initWithImage:[UIImage circleImageWithName:@"logo" borderWidth:0.5 borderColor:JYWhite]];
        _userImageView.frame = CGRectMake(kWindowW/2-40, kWindowH/2-15-tabviewH-10-imgviewH, imgviewH, imgviewH);
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}
-(UIButton *)loginButton{
    if (!_loginButton) {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(30, kWindowH/2, kWindowW-60, textFieldH);
        _loginButton.backgroundColor = JYButtonColor;
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
        self.passwordField = [[UITextField  alloc]initWithFrame:CGRectMake(0, 0, kWindowW, textFieldH)];
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
        self.userNameField = [[UITextField  alloc]initWithFrame:CGRectMake(0, 0, kWindowW, textFieldH)];
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
        [rightButton addTarget:self action:@selector(historyLogin:) forControlEvents:UIControlEventTouchUpInside];
        _userNameField.rightView = rightButton;
        _userNameField.rightViewMode = UITextFieldViewModeUnlessEditing;
    }
    return _userNameField;
}
-(UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, kWindowH/2-15-tabviewH, kWindowW, tabviewH)];
        _tableView.backgroundColor = JYWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = kRGBColor(239, 239, 239);
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.loginButton];
        [self.view addSubview:self.userImageView];
        //注册按钮
        [self.registerButton bk_addEventHandler:^(id sender) {
            JYPhoneNumViewController *phoneNumVC = [[JYPhoneNumViewController alloc]init];
            phoneNumVC.lvc = self;
//            [self presentViewController:phoneNumVC animated:YES completion:nil];
            [rootVC addChildViewController:phoneNumVC];
            [rootVC.view addSubview:phoneNumVC.view];
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.registerButton];
        [self.view addSubview:self.touristButton];
    }
    return self;
}
//-(void)viewWillAppear:(BOOL)animated{
//    //隐藏导航栏
//    self.navigationController.navigationBarHidden = YES;
//    //隐藏导航栏之后，修改默认视图不下移
//    self.automaticallyAdjustsScrollViewInsets = NO;// 自动滚动调整，默认为YES
//   
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:IMLoginCustomUserID];
    self.password = [[NSUserDefaults standardUserDefaults] objectForKey:IMLoginPassword];
    //游客按
    [self.touristButton bk_addEventHandler:^(id sender) {
        [self removeFromParentViewController];
        [[self view] removeFromSuperview];
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMLoginNotification object:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:IMLogoutNotification object:nil];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -响应方法
-(void)historyLogin:(UIButton *)sender {
    NSLog(@"显示登录历史");
    
}

- (void)login:(UIButton *)sender {
    //是否停止旋转logo
    _isStop = NO;
    if (sender != self.loginButton) {
        return;
    }
    [[self view] endEditing:YES];
    
    
    self.userName = self.userNameField.text;
    self.password = self.passwordField.text;
    
    if ([self.userName length] > 0) {
        if ([self.password length] == 0) {
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
        NSDictionary *parms = @{@"password":self.password,@"username":self.userName};
        [JYLoginManager loginOrRegisterWith:parms Login:YES completionHandle:^(JYLoginRegisterModel *model, NSError *error) {
            if ([model.status isEqualToString:@"0"]) {
                _notifyText = model.error_msg;
                _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
                [self displayNotifyHUD];
                return ;
            }
            //获取登录成功返回的用户数据
            UserData *data = model.data;
            //[g_pIMMyself setDelegate:self];
//            [g_pIMMyself setCustomUserID:data.name];
            [g_pIMMyself setCustomUserID:data.name];
            [g_pIMMyself setPassword:self.password];
            [g_pIMMyself setAutoLogin:YES];
            [g_pIMMyself loginWithTimeoutInterval:5 success:^{
                _isStop = YES;
                [[NSUserDefaults standardUserDefaults] setObject:data.ID forKey:IMLoginUID];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
                [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
                [[NSUserDefaults standardUserDefaults] setObject:data.tel forKey:IMLoginTEL];
                [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //应用角标清零
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                
                [self.passwordField setText:nil];
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
            } else {
        _notifyText = @"请输入用户名";
        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
        [self displayNotifyHUD];
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
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
    
//    [_loginView viewWillAppear];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        [cell addSubview:self.userNameField];
        
    } else {
        [cell addSubview:self.passwordField];
    }
    

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}


#pragma mark - textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.userImageView.transform = CGAffineTransformMakeRotation(0);
    self.loginButton.tag = 100;
    _isStop = YES;

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
-(void)loginIMSDK{
    NSLog(@"****************%ld",[g_pIMMyself loginStatus]);
}



@end
