//
//  JYPublishIdleViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/30.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPublishIdleViewController.h"
#import "JYClassifyModel.h"

/** 间隔 */
static CGFloat MARGIN = 10;
/** 商品描述的TEXTVIEW的高 */
static CGFloat DESCTV_H = 130;
/** 商品描述字数限制 */
static NSInteger LIMIT_DESC_NUM = 999;
/** 商品描述提示 */
static NSString *DESC_PLACEHOLDER = @"描述一下您的物品...";
/** 图片提示 */
static NSString *IMAGE_NOTICE = @"请上传主图和细节图，更好促进易货哦！";
/** 删除按钮的宽 */
static NSUInteger DELETE_BTN_W = 20;
/** 最多上传的图片数 */
static NSUInteger MAX_IMAGE_COUNT = 5;
static NSUInteger IMAGE_W = 100;
//#define imageWidth (kWindowW-20)/3


@interface JYPublishIdleViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

/** TableView */
@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

                    //section1

/** 标题 */
@property (nonatomic, strong) UITextField *titleTF;
/** 商品描述TV */
@property (nonatomic, strong) UITextView *descTV;
/** 添加图片的按钮 */
@property (nonatomic, strong) UIButton *imageBtn;
/** 图片选择器 */
@property (nonatomic, strong) UIImagePickerController *imagePicker;
/** 放图片的scrollView */
@property (nonatomic, strong) UIScrollView *imageScrollView;
/** 放图片的Container */
@property (nonatomic, strong) UIView *containerView;
/** 放图片的数组 */
@property (nonatomic, strong) NSMutableArray *imageArr;

                    //section2
/** 原价 */
@property (nonatomic, strong) UITextField *priceTF;
/** 现价 */
@property (nonatomic, strong) UITextField *originPriceTF;
/** 分类TF */
@property (nonatomic, strong) UITextField *classTF;
/** 分类选择 */
@property (nonatomic, strong) UIPickerView *classPicker;
/** 模型数组 */
@property (nonatomic, strong) NSArray *classArr;
/** 选中的分类 */
@property (nonatomic, strong) NSString *selectedClass;
@end

@implementation JYPublishIdleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JYLog(@"\n\n******************** 进入 发布闲置 视图 ********************\n\n");
    self.tableView.tableFooterView = [UIView new];
    
}

/** 配置滚动视图的图片 */
- (void)configScrollView{
    [self.containerView removeFromSuperview];
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MARGIN, IMAGE_W)];
    [self.imageScrollView addSubview:_containerView];
    for (int i = 0; i < self.imageArr.count; i++) {
        UIImage *image = _imageArr[i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = i*100;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake((MARGIN + IMAGE_W)*i + MARGIN, 0, IMAGE_W, IMAGE_W);
        [_containerView addSubview:imageView];
        _containerView.width += (MARGIN + IMAGE_W);
        //加入删除按钮
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.layer.cornerRadius = DELETE_BTN_W/2;
        [deleteBtn setBackgroundColor:JYGlobalBg];
        [deleteBtn setImage:[UIImage imageNamed:@"bottom_plus"] forState:UIControlStateNormal];
        deleteBtn.tag = i * 100;
        deleteBtn.frame = CGRectMake(IMAGE_W - DELETE_BTN_W, 0, DELETE_BTN_W, DELETE_BTN_W);
        deleteBtn.transform = CGAffineTransformRotate(deleteBtn.transform, M_PI_2/2);
        [deleteBtn bk_addEventHandler:^(UIButton *sender) {
            [self.imageArr removeObjectAtIndex:sender.tag/100];
            [self configScrollView];
        } forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:deleteBtn];
        
    }
    if (self.imageArr.count < MAX_IMAGE_COUNT) {
        [_containerView addSubview:self.imageBtn];
        _imageBtn.frame = CGRectMake(MARGIN + self.imageArr.count * (MARGIN + IMAGE_W), 0, IMAGE_W, IMAGE_W);
        _containerView.width += MARGIN + IMAGE_W;
        CGPoint point = CGPointMake(_imageBtn.frame.origin.x - (kWindowW - IMAGE_W - MARGIN), 0);
        if (_imageBtn.x + IMAGE_W + MARGIN > kWindowW) {
            [_imageScrollView setContentOffset:point animated:YES];
        }
    }
    _imageScrollView.contentSize = _containerView.frame.size;
}

/** 判断输入的价格是否合法 */
- (BOOL)isLegal: (NSString *)price{
    NSArray *arr = [price componentsSeparatedByString:@"."];
    for (NSString *priceStr in arr) {
        for (int i = 0; i < priceStr.length; i++) {
            char a =[priceStr characterAtIndex:i];
            if (!(a >= '0' && a <= '9')) {
                return NO;
            }
        }
    }
    return YES;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITextField *titleTF = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN, 0, cell.contentView.width - 2 * MARGIN, cell.contentView.height)];
            titleTF.placeholder = @"标题";
            titleTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:titleTF];
            self.titleTF = titleTF;
        }else if (indexPath.row == 1){
        //商品描述的textView
            self.descTV = [[UITextView alloc] init];
            _descTV.text = DESC_PLACEHOLDER;
            _descTV.frame = CGRectMake(MARGIN, MARGIN, cell.width-2*MARGIN, DESCTV_H);
            _descTV.textColor = [UIColor lightGrayColor];
            _descTV.font = [UIFont systemFontOfSize:14];
            _descTV.delegate = self;
            [cell.contentView addSubview:_descTV];
            
            /** 为TExtView加一个手势，下滑回收键盘 */
            UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
                [_descTV resignFirstResponder];
            }];
            swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
            [_descTV addGestureRecognizer:swipeGR];
        //加入滚动视图，放置图片
            UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 2*MARGIN + DESCTV_H, cell.width, IMAGE_W)];
            self.imageScrollView = imageScrollView;
            [cell.contentView addSubview:imageScrollView];
            
            imageScrollView.showsHorizontalScrollIndicator = NO;
            imageScrollView.alwaysBounceHorizontal = YES;
            

            [self configScrollView];
            
            UILabel *noticeLb = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN/2, 2*MARGIN+DESCTV_H+IMAGE_W+MARGIN/2, cell.width, MARGIN)];
            noticeLb.text = IMAGE_NOTICE;
            noticeLb.font = [UIFont systemFontOfSize:10];
            noticeLb.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:noticeLb];
        }else {
        //定位按钮
            UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            locationBtn.frame = CGRectMake(MARGIN, 0, cell.contentView.width-MARGIN, cell.contentView.height);
            [locationBtn setImage:[UIImage imageNamed:@"location_07"] forState:UIControlStateNormal];
            [locationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [locationBtn setTitle:@"浙江传媒学院" forState:UIControlStateNormal];
            [cell.contentView addSubview: locationBtn];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
        //价格原价cell
            UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, 0, kWindowW/4-MARGIN, cell.contentView.height)];
            priceLb.text = @"价格";
            [cell.contentView addSubview:priceLb];
            UITextField *priceTF = [[UITextField alloc] initWithFrame:CGRectMake(kWindowW/4, 0, kWindowW/4, cell.contentView.height)];
            priceTF.placeholder = @"¥0.00";
            [cell.contentView addSubview:priceTF];
            self.priceTF = priceTF;
            UILabel *originPriceLb = [[UILabel alloc] initWithFrame:CGRectMake(kWindowW/2, 0, kWindowW/4, cell.contentView.height)];
            originPriceLb.text = @"原价";
            [cell.contentView addSubview:originPriceLb];
            UITextField *originPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(kWindowW/4*3, 0, kWindowW/4, cell.contentView.height)];
            originPriceTF.placeholder = @"¥0.00";
            [cell.contentView addSubview:originPriceTF];
            self.originPriceTF = originPriceTF;
        }else if(indexPath.row == 1){
        //分类cell
            UILabel *classLb = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, 0, kWindowW/4-MARGIN, cell.contentView.height)];
            classLb.text = @"分类";
            [cell.contentView addSubview:classLb];
            UITextField *classTF = [[UITextField alloc] initWithFrame:CGRectMake(kWindowW/4-MARGIN, 0, cell.contentView.width-(kWindowW/4-MARGIN), cell.contentView.height)];
            classTF.placeholder = @"请选择分类";
            self.classTF = classTF;
            classTF.inputView = self.classPicker;
            [cell.contentView addSubview:classTF];
        }else{
        //发布cell
            cell.height = 50;
            UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            publishBtn.frame = CGRectMake(MARGIN/2, MARGIN/2, cell.contentView.width-MARGIN, cell.height-MARGIN);
            [publishBtn setBackgroundColor:JYGlobalBg];
            [publishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
            [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:publishBtn];
            [publishBtn bk_addEventHandler:^(id sender) {
                [self.classTF resignFirstResponder];
                if ([self isLegal:self.priceTF.text] && [self isLegal:self.originPriceTF.text]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入正确的价格" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.priceTF becomeFirstResponder];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            } forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

kRemoveCellSeparator

/** 各种高 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 50;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 4*MARGIN + DESCTV_H + IMAGE_W+MARGIN/2;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==1?10:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section==0?10:0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        self.selectedClass = [[model.name stringByAppendingString:@"-"] stringByAppendingString:model.subClass[row]];
        self.classTF.text = self.selectedClass;
    }
}

#pragma mark *** UIImagePickerControllerDelegate ***

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    JYLog(@"选择了图片");
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.imageArr addObject:image];
    [self configScrollView];
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
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
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

- (UIButton *)imageBtn {
	if(_imageBtn == nil) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
        [_imageBtn bk_addEventHandler:^(id sender) {
            JYLog(@"选图片选图片选图片");
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } forControlEvents:UIControlEventTouchUpInside];
	}
	return _imageBtn;
}



- (NSMutableArray *)imageArr {
	if(_imageArr == nil) {
		_imageArr = [[NSMutableArray alloc] init];
	}
	return _imageArr;
}

@end
