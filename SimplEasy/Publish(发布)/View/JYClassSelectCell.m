//
//  JYClassSelectCell.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/5.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYClassSelectCell.h"
#import "JYClassifyModel.h"


/** 间隔 */
static const CGFloat MARGIN = 10;

@interface JYClassSelectCell () <UIPickerViewDelegate,UIPickerViewDataSource>
/** 分类 */
@property (nonatomic, strong) UILabel *classLb;
/** 分类选择 */
@property (nonatomic, strong) UIPickerView *classPicker;
/** 模型数组 */
@property (nonatomic, strong) NSArray *classArr;
/** 选中的分类 */
@property (nonatomic, strong) NSString *selectedClass;

@end


@implementation JYClassSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self classLb];
    [self classTF];
    return self;
}

#pragma mark *** <UIPickerViewDataSource> ***

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.classArr.count;
    }
    NSInteger index = [pickerView selectedRowInComponent:0];
    JYClassifyModel *model = self.classArr[index];
    return model.subClass.count;
}

#pragma mark *** <UIPickerViewDelegate> ***

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        JYClassifyModel *model = self.classArr[row];
        return model.name;
    }else{
        NSInteger index = [pickerView selectedRowInComponent:0];
        JYClassifyModel *model = self.classArr[index];
        return row<model.subClass.count?model.subClass[row]:nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [self.classPicker reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }else{
        NSInteger index = [pickerView selectedRowInComponent:0];
        JYClassifyModel *model = self.classArr[index];
        self.selectedClass = row<model.subClass.count?[[model.name stringByAppendingString:@"-"] stringByAppendingString:model.subClass[row]]:nil;
        self.classTF.text = self.selectedClass;
    }
}

- (UILabel *)classLb {
	if(_classLb == nil) {
		_classLb = [[UILabel alloc] init];
        _classLb.text = @"分类";
        [self.contentView addSubview:_classLb];
        [_classLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.top.bottom.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(kWindowW/4-MARGIN);
        }];
	}
	return _classLb;
}

- (UITextField *)classTF {
	if(_classTF == nil) {
		_classTF = [[UITextField alloc] init];
        _classTF.placeholder = @"请选择分类";
        _classTF.inputView = self.classPicker;
        [self.contentView addSubview:_classTF];
        [_classTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.classLb.mas_right).mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-MARGIN);
        }];
	}
	return _classTF;
}

- (UIPickerView *)classPicker {
    if(_classPicker == nil) {
        _classPicker = [[UIPickerView alloc] init];
        _classPicker.delegate = self;
        _classPicker.dataSource = self;
    }
    return _classPicker;
}

- (NSArray *)classArr {
    if(_classArr == nil) {
        _classArr = [JYClassifyModel classModels];
    }
    return _classArr;
}


@end
