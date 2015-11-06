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
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
/** 等级 */
@property (weak, nonatomic) IBOutlet UIImageView *rankIV;
/** 评论 */
@property (weak, nonatomic) IBOutlet UILabel *commentLb;
/** 点赞 */
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;

@end
