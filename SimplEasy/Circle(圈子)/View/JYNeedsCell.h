//
//  JYNeedsCell.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/16.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNeedsCell : UITableViewCell

@property (nonatomic, strong) UILabel *needsLb;
/** 是否是急需 */
@property (nonatomic, getter=isUrgent) BOOL urgent;

@property (nonatomic, strong) UILabel *timeLb;

@property (nonatomic, strong) UIImageView *headImg;
@end
