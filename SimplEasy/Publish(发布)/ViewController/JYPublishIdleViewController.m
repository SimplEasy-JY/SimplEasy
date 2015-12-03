//
//  JYPublishIdleViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/30.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPublishIdleViewController.h"
#import "JYClassifyModel.h"

static CGFloat margin = 10;
static CGFloat descTVHeight = 100;

#define imageWidth (kWindowW-20)/3

@interface JYPublishIdleViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

/** TableView */
@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
/** 商品描述TV */
@property (nonatomic, strong) UITextView *descTV;
/** 分类选择 */
@property (nonatomic, strong) UIPickerView *classPicker;
/** 模型数组 */
@property (nonatomic, strong) NSArray *classArr;
/** 选中的分类 */
@property (nonatomic, strong) NSString *selectedClass;
/** 分类TF */
@property (nonatomic, strong) UITextField *classTF;
/** 添加图片的按钮 */
@property (nonatomic, strong) UIButton *imageBtn;
/** 图片选择器 */
@property (nonatomic, strong) UIImagePickerController *imagePicker;
/** 加图片的Cell */
@property (nonatomic, strong) UITableViewCell *imageCell;
@end

@implementation JYPublishIdleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JYLog(@"\n\n******************** 进入 发布闲置 视图 ********************\n\n");
//    [self idleView];
    self.tableView.tableFooterView = [UIView new];
    
}


#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"idleCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITextField *titleTF = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, cell.contentView.width, cell.contentView.height)];
            titleTF.placeholder = @"标题";
            [cell.contentView addSubview:titleTF];
        }else if (indexPath.row == 1){
            
            self.descTV = [[UITextView alloc] init];
            _descTV.text = @"描述一下您的物品...";
            _descTV.frame = CGRectMake(margin, margin, cell.width-2*margin, descTVHeight);
            _descTV.textColor = [UIColor lightGrayColor];
            _descTV.font = [UIFont systemFontOfSize:14];
            _descTV.delegate = self;
            [cell.contentView addSubview:_descTV];
            
            /** 为TExtView加一个手势，下滑回收键盘 */
            UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
                [_descTV resignFirstResponder];
            }];
            swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
            [_descTV addGestureRecognizer:swipeGR];
            
            self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_imageBtn setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
            _imageBtn.frame = CGRectMake(margin/2, 2*margin + descTVHeight, imageWidth, imageWidth);
            [cell.contentView addSubview: _imageBtn];
            self.imageCell = cell;
            [_imageBtn bk_addEventHandler:^(id sender) {
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            } forControlEvents:UIControlEventTouchUpInside];
        }else {
            UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            locationBtn.frame = CGRectMake(margin, 0, cell.contentView.width-margin, cell.contentView.height);
            [locationBtn setImage:[UIImage imageNamed:@"location_07"] forState:UIControlStateNormal];
            [locationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [locationBtn setTitle:@"浙江传媒学院" forState:UIControlStateNormal];
            [cell.contentView addSubview: locationBtn];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, kWindowW/4-margin, cell.contentView.height)];
            priceLb.text = @"价格";
            [cell.contentView addSubview:priceLb];
            UITextField *priceTF = [[UITextField alloc] initWithFrame:CGRectMake(kWindowW/4, 0, kWindowW/4, cell.contentView.height)];
            priceTF.placeholder = @"¥0.00";
            [cell.contentView addSubview:priceTF];
            UILabel *originPriceLb = [[UILabel alloc] initWithFrame:CGRectMake(kWindowW/2, 0, kWindowW/4, cell.contentView.height)];
            originPriceLb.text = @"原价";
            [cell.contentView addSubview:originPriceLb];
            UITextField *originPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(kWindowW/4*3, 0, kWindowW/4, cell.contentView.height)];
            originPriceTF.placeholder = @"¥0.00";
            [cell.contentView addSubview:originPriceTF];
        }else if(indexPath.row == 1){
            UILabel *classLb = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, kWindowW/4-margin, cell.contentView.height)];
            classLb.text = @"分类";
            [cell.contentView addSubview:classLb];
            UITextField *classTF = [[UITextField alloc] initWithFrame:CGRectMake(kWindowW/4-margin, 0, cell.contentView.width-(kWindowW/4-margin), cell.contentView.height)];
            classTF.placeholder = @"请选择分类";
            self.classTF = classTF;
            classTF.inputView = self.classPicker;
            [cell.contentView addSubview:classTF];
        }else{
            cell.height = 50;
            UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            publishBtn.frame = CGRectMake(margin/2, margin/2, cell.contentView.width-margin, cell.height-margin);
            [publishBtn setBackgroundColor:JYGlobalBg];
            [publishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
            [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:publishBtn];
            [publishBtn bk_addEventHandler:^(id sender) {
                [self.classTF resignFirstResponder];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            } forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

kRemoveCellSeparator

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 50;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 3*margin + descTVHeight + imageWidth;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==1?10:0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark *** UITextViewDelegate ***

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"描述一下您的物品..."]) {
        textView.text = @"";
    }
    self.descTV.textColor = [UIColor darkTextColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if (self.descTV.text.length == 0) {
        self.descTV.text = @"描述一下您的物品...";
        self.descTV.textColor = [UIColor lightGrayColor];
    }
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
        return model.subClass[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [self.classPicker reloadComponent:1];
    }else{
        NSInteger index = [pickerView selectedRowInComponent:0];
        JYClassifyModel *model = self.classArr[index];
        self.selectedClass = [[model.name stringByAppendingString:@"-"] stringByAppendingString:model.subClass[row]];
        self.classTF.text = self.selectedClass;
    }
}

#pragma mark *** UIImagePickerControllerDelegate ***

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    JYLog(@"选择了图片");
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.imageBtn.frame];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.imageCell.contentView addSubview:imageView];
    self.imageBtn.x += imageWidth + margin/2;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark *** Lazy Loading ***

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[TPKeyboardAvoidingTableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        
        _tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
	return _tableView;
}

- (UIPickerView *)classPicker {
	if(_classPicker == nil) {
		_classPicker = [[UIPickerView alloc] init];
        _classPicker.delegate = self;
        _classPicker.dataSource = self;
        _classPicker.showsSelectionIndicator = YES;
	}
	return _classPicker;
}

- (NSArray *)classArr {
	if(_classArr == nil) {
		_classArr = [JYClassifyModel classModels];
	}
	return _classArr;
}

- (UIImagePickerController *)imagePicker {
	if(_imagePicker == nil) {
		_imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	return _imagePicker;
}

@end
