//
//  ImageScrollCell.h
//  smgui
//
//  Created by 杨胜浩 on 15/5/25.
//  Copyright (c) 2015年 yangshenghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"

@interface ImageScrollCell : UITableViewCell

/**  滚动视图 */
@property(nonatomic, strong) ImageScrollView *imageScrollView;
///**< 图片URL */
//@property(nonatomic, strong) NSArray *imageArray;

//-(void)setImageArray:(NSArray *)imageArray;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame imageArray:(NSArray *)imageArray;

@end
