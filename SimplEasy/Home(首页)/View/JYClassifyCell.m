//
//  JYClassifyCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/21.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassifyCell.h"
#import "UILabel+Line.h"

static CGFloat cellH = 108.0;
static CGFloat margin = 10.0;
static CGFloat productImgW = 100.0;
static CGFloat descFont = 14.0;
static CGFloat priceFont = 18.0;
static CGFloat originPFont = 14.0;
static CGFloat locIvH = 12;
static CGFloat schoolLbFont = 12.0;
static CGFloat publishDateFont = 12.0;

@implementation JYClassifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.height = cellH;
    return self;
}

- (UIImageView *)productIV {
    if(_productIV == nil) {
        _productIV = [[UIImageView alloc] init];
        _productIV.contentMode = UIViewContentModeScaleAspectFill;
        _productIV.clipsToBounds = YES;
        [self.contentView addSubview:_productIV];
        [_productIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(margin);
            make.bottom.mas_equalTo(-margin);
            make.width.mas_equalTo(productImgW);
        }];
        _productIV.layer.cornerRadius = 5;
        _productIV.layer.masksToBounds = YES;
    }
    return _productIV;
}

- (UILabel *)productDesc {
    if(_productDesc == nil) {
        _productDesc = [[UILabel alloc] init];
        _productDesc.font = [UIFont systemFontOfSize:descFont];
        _productDesc.numberOfLines = 2;
        [self.contentView addSubview:_productDesc];
        [_productDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(margin);
            make.left.mas_equalTo(self.productIV.mas_right).mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
        }];
    }
    return _productDesc;
}

- (UILabel *)currentPrice {
    if(_currentPrice == nil) {
        _currentPrice = [[UILabel alloc] init];
        _currentPrice.textColor = [UIColor redColor];
        _currentPrice.font = [UIFont systemFontOfSize:priceFont];
        [self.contentView addSubview:_currentPrice];
        [_currentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.productIV.mas_right).mas_equalTo(margin);
            make.top.mas_equalTo(self.productDesc.mas_bottom).mas_equalTo(margin);
        }];
    }
    return _currentPrice;
}

- (UILabel *)originPrice {
    if(_originPrice == nil) {
        _originPrice = [[UILabel alloc] init];
        _originPrice.textColor = [UIColor lightGrayColor];
        _originPrice.font = [UIFont systemFontOfSize:originPFont];
        [self.contentView addSubview:_originPrice];
        [_originPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.currentPrice.mas_right).mas_equalTo(margin/2);
            make.bottom.mas_equalTo(self.currentPrice);
        }];
        [_originPrice bk_addObserverForKeyPath:@"text" task:^(id target) {
            [target addMidLine];
        }];
    }
    return _originPrice;
}

- (UIImageView *)locationIV {
    if(_locationIV == nil) {
        _locationIV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.locationIV];
        _locationIV.contentMode = UIViewContentModeScaleAspectFit;
        [_locationIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.productIV.mas_right).mas_equalTo(margin);
            make.height.mas_equalTo(locIvH);
            make.width.mas_equalTo(locIvH);
            make.centerY.mas_equalTo(self.schoolNameLb);
        }];
    }
    return _locationIV;
}

- (UILabel *)schoolNameLb {
    if(_schoolNameLb == nil) {
        _schoolNameLb = [[UILabel alloc] init];
        _schoolNameLb.textColor = kRGBColor(106, 194, 243);
        _schoolNameLb.font = [UIFont systemFontOfSize:schoolLbFont];
        [self.contentView addSubview:_schoolNameLb];
        [_schoolNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.productIV.mas_right).mas_equalTo(margin+locIvH);
            make.bottom.mas_equalTo(-10);
        }];
        self.locationIV.image = [UIImage imageNamed:@"middleicon_32"];
    }
    return _schoolNameLb;
}

- (UILabel *)publishDateLb {
    if(_publishDateLb == nil) {
        _publishDateLb = [[UILabel alloc] init];
        _publishDateLb.font = [UIFont systemFontOfSize:publishDateFont];
        [self.contentView addSubview: _publishDateLb];
        [_publishDateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-margin);
            make.centerY.mas_equalTo(self.schoolNameLb);
        }];
    }
    return _publishDateLb;
}

@end
