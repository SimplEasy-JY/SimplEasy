//
//  JYNormalCell.h
//  SimplEasy
//
//  Created by EvenLam on 15/12/11.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNormalCell : UITableViewCell

/**
 *  设置提示的个数
 *
 *  @param value 个数，如果没有提示传nil
 */
- (void)setBadge: (NSInteger)value;

@end
