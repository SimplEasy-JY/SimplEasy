//
//  JYProductDescCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductDescCell.h"

/** 间隔 */
static const CGFloat MARGIN = 10;
/** 商品描述的TEXTVIEW的高 */
static const CGFloat DESCTV_H = 130;
/** 商品描述字数限制 */
static const NSInteger LIMIT_DESC_NUM = 999;
/** 商品描述提示 */
static NSString *DESC_PLACEHOLDER = @"描述一下您的物品...";
/** 图片提示 */
static NSString *IMAGE_NOTICE = @"请上传主图和细节图，更好促进易货哦！";
/** 滚动视图的高 */
static const NSUInteger SCROLLVIEW_H = 100;

@implementation JYProductDescCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self imageNoticeLb];
    return self;
}

- (UITextView *)descTV {
    if(_descTV == nil) {
        _descTV = [[UITextView alloc] init];
        [self.contentView addSubview: _descTV];
        [_descTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.right.mas_equalTo(-MARGIN);
            make.top.mas_equalTo(MARGIN);
            make.height.mas_equalTo(DESCTV_H);
        }];
        _descTV.text = DESC_PLACEHOLDER;
        _descTV.textColor = [UIColor lightGrayColor];
        _descTV.font = [UIFont systemFontOfSize:14];
        _descTV.delegate = self;
        
        /** 为TExtView加一个手势，左滑回收键盘 */
        UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [_descTV resignFirstResponder];
        }];
        swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
        [_descTV addGestureRecognizer:swipeGR];
    }
    return _descTV;
}

- (UIScrollView *)imageScrollView {
    if(_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] init];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_imageScrollView];
        [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.descTV.mas_bottom).mas_equalTo(MARGIN);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(SCROLLVIEW_H);
        }];
    }
    return _imageScrollView;
}

- (UILabel *)imageNoticeLb {
    if(_imageNoticeLb == nil) {
        _imageNoticeLb = [[UILabel alloc] init];
        _imageNoticeLb.text = IMAGE_NOTICE;
        _imageNoticeLb.font = [UIFont systemFontOfSize:10];
        _imageNoticeLb.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_imageNoticeLb];
        [_imageNoticeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.right.mas_equalTo(-MARGIN);
            make.top.mas_equalTo(self.imageScrollView.mas_bottom).mas_equalTo(MARGIN/2);
            make.bottom.mas_equalTo(-MARGIN/2);
        }];
    }
    return _imageNoticeLb;
}

#pragma mark *** UITextViewDelegate ***

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>LIMIT_DESC_NUM) {
        textView.text = [textView.text substringToIndex:LIMIT_DESC_NUM];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:DESC_PLACEHOLDER]) {
        textView.text = @"";
    }
    self.descTV.textColor = [UIColor darkTextColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if (self.descTV.text.length == 0) {
        self.descTV.text = DESC_PLACEHOLDER;
        self.descTV.textColor = [UIColor lightGrayColor];
    }
}
@end
