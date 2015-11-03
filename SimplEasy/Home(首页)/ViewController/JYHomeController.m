//
//  ViewController.m
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYHomeController.h"
#import "UIBarButtonItem+Extension.h"

@interface JYHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@end

@implementation JYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setNav];
    [self initTableView];
}


-(void)initData{

}
-(void)setNav{
    //左边的分类选择
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(changeCategory:) image:@"topicon_1" highImage:@"topicon_1"];
    
    
    
    //中间的搜索条
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    UITextField *searchField;
    NSUInteger numViews = [searchBar.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[searchBar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [searchBar.subviews objectAtIndex:i];
        }
    }
    if((searchField.text == nil)) {
        searchField.placeholder = @"输入要查找的艺人的名字";
        
        [searchField setBorderStyle:UITextBorderStyleRoundedRect];
        [searchField setBackgroundColor:[UIColor whiteColor]];
        
        //自己的搜索图标
        NSString *path = [[NSBundle mainBundle] pathForResource:@"topicon_2" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        [iView setFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        searchField.leftView = iView;
        
        
    }
//    searchBar.placeholder = @"简易破蛋日全场大甩卖";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    //右边的item
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(changeCategory:) image:@"topicon_2" highImage:@"topicon_2"];
    

}
-(void)initTableView{

}
@end
