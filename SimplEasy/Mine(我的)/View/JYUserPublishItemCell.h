//
//  JYUserPublishItemCell.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/14.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYUserPublishItemCell : UITableViewCell

/** 闲置 */
@property (nonatomic, strong) UIButton *idleBtn;
/** 需求 */
@property (nonatomic, strong) UIButton *needsBtn;
/** 易友 */
@property (nonatomic, strong) UIButton *friendBtn;

/** 闲置数量 */
@property (nonatomic, strong) UILabel *idleNum;
/** 需求数量 */
@property (nonatomic, strong) UILabel *needsNum;
/** 易友数量 */
@property (nonatomic, strong) UILabel *friendNum;

- (void)addIdleTarget: (id)target selector: (SEL)selector forControlEvents: (UIControlEvents)event;
- (void)addNeedsTarget: (id)target selector: (SEL)selector forControlEvents: (UIControlEvents)event;
- (void)addFriendTarget: (id)target selector: (SEL)selector forControlEvents: (UIControlEvents)event;



@end
