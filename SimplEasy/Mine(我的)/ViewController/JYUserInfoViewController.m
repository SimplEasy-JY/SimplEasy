//
//  JYUserInfoViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/13.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYUserInfoViewController.h"
#import "UIImage+Circle.h"

#import "IMDefine.h"
#import "IMMyselfInfoEditViewController.h"

#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMMyself+CustomUserInfo.h"
#import "IMSDK+MainPhoto.h"
#import "IMMyself+MainPhoto.h"
#import "IMMyself+Nickname.h"
#import "IMSDK+CustomUserInfo.h"

@interface JYUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IMMyselfInfoEditDelegate,IMCustomUserInfoDelegate,IMSDKCustomUserInfoDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYUserInfoViewController{
    UITableView *_tableView;
    
    NSArray *_customInfoArray;
    NSString *_sex;
    NSString *_location;
    NSString *_school;
    NSString *_signature;
    NSString *_nickname;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:IMCustomUserInfoDidInitializeNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [g_pIMSDK setCustomUserInfoDelegate:self];
    [g_pIMMyself setCustomUserInfoDelegate:self];
    self.tableView.tableFooterView = [UIView new];
    [self loadData];
    
}
#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section==0 && indexPath.row==0)?80:45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UserInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            UIImage *image = nil;
            
            image = [g_pIMSDK mainPhotoOfUser:[g_pIMMyself customUserID]];
            
            if (image == nil) {
                if ([_sex isEqualToString:@"女"]) {
                    image = [UIImage imageNamed:@"IM_head_female.png"];
                } else {
                    image = [UIImage imageNamed:@"IM_head_male.png"];
                }
            }
            image = [UIImage scaleToSize:image size:CGSizeMake(60, 60)];
            image = [UIImage circleImageWithImage:image borderWidth:0.5 borderColor:[UIColor whiteColor]];
            
            cell.accessoryView = [[UIImageView alloc] initWithImage:image];
            [[cell textLabel] setText:@"头像"];
        }else if (indexPath.row == 1){
            [[cell textLabel] setText:@"昵称"];
            if (_nickname.length) {
                cell.detailTextLabel.text = _nickname;
            } else {
                cell.detailTextLabel.text = @"未设置";
            }
            
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"简易号";
            cell.detailTextLabel.text = [g_pIMMyself customUserID];
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"个性签名";
            if (_signature.length > 0) {
                cell.detailTextLabel.text = _signature;
            } else {
                cell.detailTextLabel.text = @"未填写";
            }
        }
        
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"性别";
            if (_sex.length > 0) {
                cell.detailTextLabel.text = _sex;
            } else {
                cell.detailTextLabel.text = @"男";
            }
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"地区";
            if (_location.length > 0) {
                cell.detailTextLabel.text = _location;
            } else {
                cell.detailTextLabel.text = @"未填写";
            }
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"学校";
            if (_school.length > 0) {
                cell.detailTextLabel.text = _school;
            } else {
                cell.detailTextLabel.text = @"未填写";
            }
        }
        
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
    
}
kRemoveCellSeparator
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tableView;
}
#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择",nil];
        
        [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
        [actionSheet showFromTabBar:[self tabBarController].tabBar];
        return;
    }
    if (indexPath.row == 2 && indexPath.section == 0) {
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        return;
    }
    IMMyselfInfoEditViewController *controller = [[IMMyselfInfoEditViewController alloc] init];
    NSString *content = nil;
    if ([indexPath row] == 1 && indexPath.section == 0) {
        content = [g_pIMMyself nickname];
    } else if (indexPath.row == 3 && indexPath.section == 0){
        content = [_customInfoArray objectAtIndex:0];
    }else {
        if (_customInfoArray.count > (indexPath.row+1)) {
            content = [_customInfoArray objectAtIndex:(indexPath.row+1)];
        }
    }
    [controller setDelegate:self];
    [controller setContent:content];
    [controller setType:indexPath.section == 0? indexPath.row:(indexPath.row+4)];
    [[self navigationController] pushViewController:controller animated:YES];
    
}


#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        UIImagePickerController *picker  = [[UIImagePickerController alloc] init];
        [picker setEdgesForExtendedLayout:UIRectEdgeNone];
        
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            return;
        }
        UIImagePickerController *picker  = [[UIImagePickerController alloc] init];
        
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
    
}


#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = nil;
    
    image = [info valueForKey:UIImagePickerControllerEditedImage];
    if (image) {
        image = [UIImage scaleToSize:image size:CGSizeMake(60, 60)];
        image = [UIImage circleImageWithImage:image borderWidth:0.5 borderColor:[UIColor whiteColor]];
        [g_pIMMyself uploadMainPhoto:image success:^{
            _notifyText = @"上传头像成功";
            _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
            [self displayNotifyHUD];
            
            UITableViewCell *cell = [[_tableView visibleCells] objectAtIndex:0];
            
            cell.accessoryView = [[UIImageView alloc] initWithImage:image];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadMainPhotoNotification object:[g_pIMMyself customUserID]];
            
        } failure:^(NSString *error) {
            _notifyText = @"上传头像失败";
            _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
            [self displayNotifyHUD];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IMMyselfInfoEdit delegate

- (void)customUerInfoEdit:(NSInteger)type content:(NSString *)content {
    switch (type) {
        case 1:
        {
            _nickname = content;
            
            [_tableView reloadData];
            
            [g_pIMMyself commitNickname:content succuss:^{
                _notifyText = @"修改成功";
                _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
                [self displayNotifyHUD];
            [[NSNotificationCenter defaultCenter] postNotificationName:IMCustomUserInfoDidInitializeNotification object:[g_pIMMyself customUserID]];
            } failure:^(NSString *error) {
                _notifyText = @"修改信息失败";
                _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
                [self displayNotifyHUD];
                [_tableView reloadData];
            }];
            return;
        }
        case 2:
        {
            break;
        }
        case 3:
        {
            _signature = content;
        }
            break;
        case 4:
        {
            _sex = content;
        }
            break;
        case 5:
        {
            _location = content;
        }
            break;
        case 6:
        {
            _school = content;
        }
            break;
        default:
            break;
    }
    
    _customInfoArray = [NSArray arrayWithObjects:_signature, _sex, _location,_school, nil];
    [_tableView reloadData];
    
    [g_pIMMyself commitCustomUserInfo:[_customInfoArray componentsJoinedByString:@"\n"] success:^{
        _notifyText = @"修改成功";
        _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
        [self displayNotifyHUD];
        if (type == 3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:IMCustomUserInfoDidInitializeNotification object:[g_pIMMyself customUserID]];
        }
        
    } failure:^(NSString *error) {
        
        _notifyText = @"修改信息失败";
        _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
        [self displayNotifyHUD];
        
        NSString *customInfo = [g_pIMSDK customUserInfo];
        
        _customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
        
        if ([_customInfoArray count] > 0) {
            _signature = [_customInfoArray objectAtIndex:0];
        }
        if ([_customInfoArray count] > 1) {
            _sex = [_customInfoArray objectAtIndex:1];
        }
        if ([_customInfoArray count] > 2) {
            _location = [_customInfoArray objectAtIndex:2];
        }
        if ([_customInfoArray count] > 3) {
            _school = [_customInfoArray objectAtIndex:3];
        }
        
        [_tableView reloadData];
    }];
}
- (void)didCommitCustomUserInfo:(NSString *)customUserInfo clientCommitTime:(UInt32)timeIntervalSince1970{
    [g_pIMSDK requestCustomUserInfoWithCustomUserID:[g_pIMMyself customUserID]];
    NSLog(@"info *********** %@",customUserInfo);
}
/*获取用户信息成功回调API*/
- (void)didRequestCustomUserInfo:(NSString *)customUserInfo withCustomUserID:(NSString *)customUserID clientRequestTime:(UInt32)timeIntervalSince1970{
    NSLog(@"request customUserInfo:%@'s customUserInfo successed at client time,customInfo is%@",customUserID,customUserInfo);
}

#pragma mark - notifications

- (void)loadData {
    NSString *customInfo = [g_pIMMyself customUserInfo];
    
    _sex = @"";
    _signature = @"";
    _location = @"";
    _customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
    
    if ([_customInfoArray count] > 0) {
        _signature = [_customInfoArray objectAtIndex:0];
    }
    if ([_customInfoArray count] > 1) {
        _sex = [_customInfoArray objectAtIndex:1];
    }
    if ([_customInfoArray count] > 2) {
        _location = [_customInfoArray objectAtIndex:2];
    }
    _nickname = [g_pIMMyself nickname];
    
    [_tableView reloadData];
}


#pragma mark - notify hud

- (BDKNotifyHUD *)notify {
    if (_notify != nil){
        return _notify;
    }
    
    _notify = [BDKNotifyHUD notifyHUDWithImage:_notifyImage text:_notifyText];
    [_notify setCenter:CGPointMake(self.tabBarController.view.center.x, self.tabBarController.view.center.y - 20)];
    return _notify;
}

- (void)displayNotifyHUD {
    if (_notify) {
        [_notify removeFromSuperview];
        _notify = nil;
    }
    
    [self.tabBarController.view addSubview:[self notify]];
    [[self notify] presentWithDuration:1.0f speed:0.5f inView:self.tabBarController.view completion:^{
        [[self notify] removeFromSuperview];
    }];
}

@end
