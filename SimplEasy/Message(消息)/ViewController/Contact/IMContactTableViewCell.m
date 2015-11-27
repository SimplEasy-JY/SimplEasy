//
//  IMContactTableViewCell.m
//  IMDeveloper
//
//  Created by mac on 14-12-11.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMContactTableViewCell.h"
#import "IMDefine.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"
#import "IMSDK+Nickname.h"

@implementation IMContactTableViewCell {
    UIImageView *_headView;
    UILabel *_usernameLabel;
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
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
        
        [[_headView layer] setCornerRadius:17.0f];
        [_headView setContentMode:UIViewContentModeScaleAspectFill];
        [_headView setClipsToBounds:YES];
        [[self contentView] addSubview:_headView];
        
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, 200, 36)];
        
        [_usernameLabel setBackgroundColor:[UIColor clearColor]];
        [_usernameLabel setTextColor:[UIColor blackColor]];
        [_usernameLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        [[self contentView] addSubview:_usernameLabel];
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
    
    if ([nickname length]) {
        showText = [NSString stringWithFormat:@"%@（%@）",_customUserID,nickname];
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
    
    if ([nickname length]) {
        showText = [NSString stringWithFormat:@"%@（%@）",_customUserID,nickname];
    } else {
        showText = _customUserID;
    }
    [_usernameLabel setText:showText];
}
@end
