//
//  JYCommentCell.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYCommentCell : UITableViewCell

/** 头像 */
@property (nonatomic, strong) UIImageView *headIV;
/** 昵称 */
@property (nonatomic, strong) UILabel *nickNameLb;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLb;
/** 等级 */
@property (nonatomic, strong) UIImageView *rankIV;
/** 评论 */
@property (nonatomic, strong) UILabel *commentLb;
/** 点赞 */
@property (nonatomic, strong) UIButton *goodBtn;

@end