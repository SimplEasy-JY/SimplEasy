//
//  ImageScrollCell.m
//  smgui
//
//  Created by 杨胜浩 on 15/5/25.
//  Copyright (c) 2015年 yangshenghao. All rights reserved.
//

#import "ImageScrollCell.h"

@implementation ImageScrollCell

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        NSLog(@"imageArr:%ld",self.imageArr.count);
//        self.imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 180) ImageArray:self.imageArr];
//        [self.contentView addSubview:self.imageScrollView];
//    }
//    return self;
//}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame imageArray:(NSArray *)imageArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"imageArr:%ld",imageArray.count);
        self.imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) ImageArray:imageArray];
        [self.contentView addSubview:self.imageScrollView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)setImageArray:(NSArray *)imageArray{
//    [self.imageScrollView setImageArray:imageArray];
//}
//
//-(void)setImageArr:(NSArray *)imageArr{
//    _imageArr = imageArr;
//    [self.imageScrollView setImageArray:imageArr];
//}

@end
