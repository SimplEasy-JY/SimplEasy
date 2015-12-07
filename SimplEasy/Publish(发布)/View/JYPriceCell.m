//
//  JYPriceCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPriceCell.h"


/** 间隔 */
static CGFloat MARGIN = 10;

@interface JYPriceCell ()


/** 价格 */
@property (nonatomic, strong) UILabel *priceLb;
/** 原价 */
@property (nonatomic, strong) UILabel *originPriceLb;

@end

@implementation JYPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self priceLb];
    [self priceTF];
    [self originPriceLb];
    [self originPriceTF];
    
    return self;
}

- (UILabel *)priceLb {
    if(_priceLb == nil) {
        _priceLb = [[UILabel alloc] init];
        _priceLb.text = @"价格";
        [self.contentView addSubview:_priceLb];
        [_priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.top.bottom.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(kWindowW/4-MARGIN);
        }];
    }
    return _priceLb;
}

- (UITextField *)priceTF {
    if(_priceTF == nil) {
        _priceTF = [[UITextField alloc] init];
        _priceTF.placeholder = @"¥0.00";
        [self.contentView addSubview:_priceTF];
        [_priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.priceLb.mas_right).mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kWindowW/4);
        }];
    }
    return _priceTF;
}

- (UILabel *)originPriceLb {
    if(_originPriceLb == nil) {
        _originPriceLb = [[UILabel alloc] init];
        _originPriceLb.text = @"原价";
        [self.contentView addSubview:_originPriceLb];
        [_originPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.priceTF.mas_right).mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kWindowW/4);
        }];
    }
    return _originPriceLb;
}

- (UITextField *)originPriceTF {
    if(_originPriceTF == nil) {
        _originPriceTF = [[UITextField alloc] init];
        _originPriceTF.placeholder = @"¥0.00";
        [self.contentView addSubview:_originPriceTF];
        [_originPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.originPriceLb.mas_right).mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kWindowW/4);
        }];
    }
    return _originPriceTF;
}




@end
