//
//  JYPublishIdleViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/30.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYPublishIdleViewController.h"
#import "JYClassifyModel.h"
#import "JYTitleCell.h"
#import "JYProductDescCell.h"
#import "JYPriceCell.h"
#import "JYClassSelectCell.h"
#import "JYPublishCell.h"

/** 间隔 */
static const CGFloat MARGIN = 10;
/** 删除按钮的宽 */
static const NSUInteger DELETE_BTN_W = 13;
/** 最多上传的图片数 */
static const NSUInteger MAX_IMAGE_COUNT = 5;
static const NSUInteger IMAGE_W = 100;

@interface JYPublishIdleViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

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

@end

@implementation JYPublishIdleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JYLog(@"\n\n******************** 进入 发布闲置 视图 ********************\n\n");
    self.tableView.tableFooterView = [UIView new];
    [JYFactory addBackItemToVC:self];
    
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
        [deleteBtn setImage:[UIImage imageNamed:@"removeImageButton"] forState:UIControlStateNormal];
        deleteBtn.tag = i * 100;
        deleteBtn.frame = CGRectMake(IMAGE_W - DELETE_BTN_W, 0, DELETE_BTN_W, DELETE_BTN_W);
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
    NSString *regex = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:price];
}

/** 发布 */
- (void)publish{
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
}

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JYTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            self.titleTF = cell.titleTF;
            return cell;
        }else if (indexPath.row == 1){
            JYProductDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductDescCell"];
            self.descTV  = cell.descTV;
            self.imageScrollView = cell.imageScrollView;
            [self configScrollView];
            return cell;
        }else {
        //定位按钮
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            cell.imageView.image = [UIImage imageNamed:@"location_07"];
            cell.textLabel.text = @"浙江传媒学院";
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            JYPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
            self.priceTF = cell.priceTF;
            self.originPriceTF = cell.originPriceTF;
            return cell;
        }else if(indexPath.row == 1){
            JYClassSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassSelectCell"];
            self.classTF = cell.classTF;
            return cell;
        }else{
            JYPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishCell"];
            [cell.publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    return nil;
    
}

#pragma mark *** <UITableViewDelegate> ***

kRemoveCellSeparator

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==1?10:0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark *** UIImagePickerControllerDelegate ***

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    JYLog(@"选择了图片");
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.imageArr addObject:image];
    [self configScrollView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView registerClass:[JYTitleCell class] forCellReuseIdentifier:@"TitleCell"];
        [_tableView registerClass:[JYProductDescCell class] forCellReuseIdentifier:@"ProductDescCell"];
        [_tableView registerClass:[JYPriceCell class] forCellReuseIdentifier:@"PriceCell"];
        [_tableView registerClass:[JYClassSelectCell class] forCellReuseIdentifier:@"ClassSelectCell"];
        [_tableView registerClass:[JYPublishCell class] forCellReuseIdentifier:@"PublishCell"];
    }
	return _tableView;
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
