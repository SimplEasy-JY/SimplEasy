//
//  JYSellerCell.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSellerCell : UITableViewCell
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
/** 学校 */
@property (weak, nonatomic) IBOutlet UILabel *schoolLb;
/** 等级 */
@property (weak, nonatomic) IBOutlet UIImageView *rankIV;
/** 加关注 */
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end
