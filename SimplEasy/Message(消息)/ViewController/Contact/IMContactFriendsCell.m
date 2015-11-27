//
//  IMContactTableViewCell.m
//  IMDeveloper
//
//  Created by mac on 14-12-11.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMContactFriendsCell.h"
#import "IMDefine.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"
#import "IMSDK+Nickname.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMMyself+CustomUserInfo.h"

@implementation IMContactFriendsCell {
    UIImageView *_headView;
    UILabel *_usernameLabel;
    UILabel *_signatureLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        
        [[_headView layer] setCornerRadius:30.0f];
        [_headView setContentMode:UIViewContentModeScaleAspectFill];
        [_headView setClipsToBounds:YES];
        [[self contentView] addSubview:_headView];
        
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, kWindowW-70*2, 30)];
        [_usernameLabel setBackgroundColor:[UIColor clearColor]];
        [_usernameLabel setTextColor:[UIColor blackColor]];
        [_usernameLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [[self contentView] addSubview:_usernameLabel];
        

        _signatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5+30, kWindowW-70*2, 30)];
        [_signatureLabel setBackgroundColor:[UIColor clearColor]];
        [_signatureLabel setTextColor:[UIColor grayColor]];
        [_signatureLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [[self contentView] addSubview:_signatureLabel];
    }
    return self;
}

- (void)setHeadPhoto:(UIImage *)headPhoto {
    _headPhoto = headPhoto;
    
    if (_headPhoto == nil) {
        _headPhoto = [UIImage imageNamed:@"IM_head_male.png"];
    }
    
    [_headView setImage:_headPhoto];
}

- (void)setCustomUserID:(NSString *)customUserID {
    _customUserID = customUserID;
    
    NSString *showText = nil;
    NSString *nickname = [g_pIMSDK nicknameOfUser:customUserID];
    NSString *_signature = nil;
    NSString *customUserInfo = [g_pIMSDK customUserInfoWithCustomUserID:_customUserID];
    NSArray *array = [customUserInfo componentsSeparatedByString:@"\n"];
    if ([array count] > 0) {
        _signature = [array objectAtIndex:0];
    }
    if ([nickname length]) {
        showText = [NSString stringWithFormat:@"%@（%@）",nickname,_signature];
    } else {
        showText = _customUserID;
    }
    [_usernameLabel setText:showText];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeadImage:) name:IMReloadMainPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNickName:) name:IMNickNameUpdatedNotification object:nil];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadHeadImage:(NSNotification *)note {
    if (![note.object isEqual:_customUserID]) {
        return;
    }
    
    _headPhoto = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headPhoto == nil) {
        _headPhoto = [UIImage imageNamed:@"IM_head_male.png"];
    }
    
    [_headView setImage:_headPhoto];
}

- (void)reloadNickName:(NSNotification *)note {
    if (![note.object isEqualToString:_customUserID]) {
        return;
    }
    
    NSString *showText = nil;
    NSString *nickname = [g_pIMSDK nicknameOfUser:_customUserID];
    NSString *customUserInfo = [g_pIMSDK customUserInfoWithCustomUserID:_customUserID];
    NSArray *customInfoArray = [customUserInfo componentsSeparatedByString:@"\n"];
    NSString *signature = nil;
    if ([customInfoArray count] > 1) {
        signature = [customInfoArray objectAtIndex:0];
    }
    if ([nickname length]) {
        showText = nickname;
    } else {
        showText = _customUserID;
    }
    _usernameLabel.text = showText;
    _signatureLabel.text= signature;
}
@end
