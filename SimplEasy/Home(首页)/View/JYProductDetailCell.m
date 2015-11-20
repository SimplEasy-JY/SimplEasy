//
//  JYProductDetailCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/4.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYProductDetailCell.h"
#import "UILabel+Line.h"
#import "UIButton+VerticalBtn.h"

static CGFloat verticalMargin = 5.0f;

@interface JYProductDetailCell ()

/** 放置时间地点的view */
@property (nonatomic, strong) UIView *timeAndPlaceView;
/** 小气球 */
@property (nonatomic, strong) UIImageView *locationIV;

@end

@implementation JYProductDetailCell


- (UILabel *)productDescLb {
    if(_productDescLb == nil) {
        _productDescLb = [[UILabel alloc] init];
        _productDescLb.font = [UIFont systemFontOfSize:12];
        _productDescLb.numberOfLines = 0;
        [self.contentView addSubview:_productDescLb];
        [_productDescLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(verticalMargin);
            make.right.mas_equalTo(self.contentView).mas_equalTo(-55);
        }];
    }
    return _productDescLb;
}

- (UIButton *)shareBtn {
    if(_shareBtn == nil) {
        _shareBtn = [[UIButton alloc] init];
        [_shareBtn setImage:[UIImage imageNamed:@"middleicon_16"] forState:UIControlStateNormal];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        [self.contentView addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.productDescLb);
            make.right.mas_equalTo(0);
            make.width.height.mas_equalTo(40);
        }];
        [_shareBtn centerImageAndTitleWithSpace:3.0f];
    }
    return _shareBtn;
}

- (UILabel *)currentPriceLb {
    if(_currentPriceLb == nil) {
        _currentPriceLb = [[UILabel alloc] init];
        _currentPriceLb.font = [UIFont systemFontOfSize:17];
        _currentPriceLb.textColor = [UIColor redColor];
        [self.contentView addSubview:_currentPriceLb];
        [_currentPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(verticalMargin);
            make.top.mas_equalTo(self.productDescLb.mas_bottom).mas_equalTo(verticalMargin);
        }];
    }
    return _currentPriceLb;
}

- (UILabel *)originPriceLb {
    if(_originPriceLb == nil) {
        _originPriceLb = [[UILabel alloc] init];
        _originPriceLb.font = [UIFont systemFontOfSize:14];
        _originPriceLb.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_originPriceLb];
        [_originPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.currentPriceLb.mas_bottom);
            make.left.mas_equalTo(self.currentPriceLb.mas_right).mas_equalTo(10);
        }];
    }
    return _originPriceLb;
}

- (UIView *)timeAndPlaceView {
	if(_timeAndPlaceView == nil) {
		_timeAndPlaceView = [[UIView alloc] init];
        _timeAndPlaceView.layer.cornerRadius = 10;
        [self.contentView addSubview:_timeAndPlaceView];
        [_timeAndPlaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(verticalMargin);
            make.bottom.mas_equalTo(-verticalMargin);
            make.top.mas_equalTo(self.currentPriceLb.mas_bottom).mas_equalTo(verticalMargin);
            make.height.mas_equalTo(20);
        }];
	}
	return _timeAndPlaceView;
}

- (UILabel *)publishTimeLb {
    if(_publishTimeLb == nil) {
        _publishTimeLb = [[UILabel alloc] init];
        _publishTimeLb.font = [UIFont systemFontOfSize:11];
        [self.timeAndPlaceView addSubview:_publishTimeLb];
        [_publishTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(verticalMargin);
            make.centerY.mas_equalTo(0);
            if (!_placeLb) {
                make.right.mas_equalTo(-verticalMargin);
            }
        }];
    }
    return _publishTimeLb;
}

- (UIImageView *)locationIV {
    if(_locationIV == nil) {
        _locationIV = [[UIImageView alloc] init];
        _locationIV.contentMode = UIViewContentModeScaleAspectFit;
        _locationIV.image = [UIImage imageNamed:@"middleicon_20"];
        [self.timeAndPlaceView addSubview:_locationIV];
        [_locationIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.publishTimeLb.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(self.publishTimeLb.centerY);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(20);
        }];
    }
    return _locationIV;
}

- (UILabel *)placeLb {
    if(_placeLb == nil) {
        _placeLb = [[UILabel alloc] init];
        _placeLb.font = [UIFont systemFontOfSize:11];
        [self.timeAndPlaceView addSubview:_placeLb];
        [_placeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.locationIV.mas_right).mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-verticalMargin);
        }];
    }
    return _placeLb;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.timeAndPlaceView.backgroundColor = kRGBColor(236, 236, 236);
    self.shareBtn.selected = NO;

    return self;
}



@end
