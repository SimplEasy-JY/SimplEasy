//
//  IMContactViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMContactViewController.h"
#import "IMSearchUserViewController.h"
#import "IMDefine.h"
#import "NSString+IM.h"
#import "IMUserInformationViewController.h"
#import "IMContactFriendsCell.h"
#import "IMGroupListViewController.h"
#import "IMShopListViewController.h"
#import "IMContactTableViewCell.h"

#import "pinyin.h"
#import "POAPinyin.h"

//IMSDK Headers
#import "IMMyself+Relationship.h"
#import "IMSDK+MainPhoto.h"
#import "IMSDK+CustomUserInfo.h"

@interface IMContactViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,NSURLConnectionDelegate, NSURLConnectionDataDelegate>

// add friends
- (void)addFriends:(id)sender;
//load data
- (NSMutableArray *)classifyData:(NSArray *)array;
- (void)searchUserForCustomUserID:(NSString *)searchString;
- (NSArray *)searchSubString:(NSString *)searchString inArray:(NSArray *)sourceArray;

@end

@implementation IMContactViewController {
    //Data
    NSMutableArray *_friendList;
    NSMutableArray *_searchResult;
    NSMutableArray *_friendTitles;
    NSMutableDictionary *_sectionDic;
    NSMutableData *_dataForConnection;
    
    //UI
    UIBarButtonItem *_rightBarButtonItem;
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    UILabel *_totalNumLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"我的易友"];
        [_titleLabel setText:@"我的易友"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"tab_contact.png"]];
        [[self tabBarItem] setSelectedImage:[UIImage imageNamed:@"tab_contact_.png"]];
     
        _friendTitles = [[NSMutableArray alloc] initWithCapacity:32];
        _searchResult = [[NSMutableArray alloc] initWithCapacity:32];
        _sectionDic = [[NSMutableDictionary alloc] initWithCapacity:32];
        
        //notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReloadFriendlistNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReloadBlacklistNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:IMRelationshipDidInitializeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [JYFactory addBackItemToVC:self];
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addFriends:)];
    
    [_rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(6, 191, 4) forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    CGRect rect = [[self view] bounds];
    
    rect.size.height -= 44;
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:RGB(242, 242, 242)];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:RGB(6, 191, 4)];
    [[self view] addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 44)];
    
    [_searchBar setDelegate:self];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    [_searchBar setPlaceholder:@"搜索好友"];
    
    UIView *customTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,kWindowW, 44.0)];
    
    [customTableHeaderView addSubview:_searchBar];
    [_tableView setTableHeaderView:customTableHeaderView];
    
    UIView *customTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kWindowW, 44.0)];
    
    [customTableFooterView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:customTableFooterView];
    
    _totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWindowW-20, 44)];
    
    [_totalNumLabel setBackgroundColor:[UIColor clearColor]];
    [_totalNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_totalNumLabel setTextColor:[UIColor grayColor]];
    [_totalNumLabel setNumberOfLines:0];
    [_totalNumLabel setFont:[UIFont systemFontOfSize:18]];
    [customTableFooterView addSubview:_totalNumLabel];
    
    if (![g_pIMMyself relationshipInitialized] && [g_pIMMyself loginStatus] == IMMyselfLoginStatusLogined) {
        [_totalNumLabel setText:@"正在获取好友列表..."];
        [_totalNumLabel setCenter:CGPointMake(160, 180)];
    }else if ([_friendList count] > 0) {
        NSInteger count = 0;
        
        for (NSMutableArray *array in _friendList) {
            count += [array count];
        }
        
        [_totalNumLabel setText:[NSString stringWithFormat:@"%lu位联系人",(unsigned long)count]];
        [_totalNumLabel setFrame:CGRectMake(10, 0, kWindowW-20, 44)];

    } else {
        [_totalNumLabel setText:@"您当前还没有好友，快去添加好友吧"];
        [_totalNumLabel setCenter:CGPointMake(160, 180)];

    }

    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    [_searchDisplayController setDelegate:self];
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setSearchResultsDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([_friendList count] == 0) {
        [self loadData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFriends:(id)sender {
    if (sender != _rightBarButtonItem) {
        return;
    }
    
    IMSearchUserViewController *controller = [[IMSearchUserViewController alloc] init];
    
    [controller setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)loadData {
    [_friendTitles removeAllObjects];
    [_friendList removeAllObjects];
    
    NSArray *friendList = [g_pIMMyself friends];
    
    [self performSelectorInBackground:@selector(loadFriendlist:) withObject:friendList];
   
}

- (void)loadFriendlist:(NSArray *)array {
    _friendList = [self classifyData:array];
    
    [self performSelectorOnMainThread:@selector(updateInterface:) withObject:[NSNumber numberWithInteger:[array count]] waitUntilDone:YES];
}

- (void)updateInterface:(NSNumber *)count {
    [_tableView reloadData];
    
    if (![g_pIMMyself relationshipInitialized] && [g_pIMMyself loginStatus] == IMMyselfLoginStatusLogined) {
        [_totalNumLabel setText:@"正在获取好友列表..."];
        [_totalNumLabel setCenter:CGPointMake(160, 180)];
    }else if ([_friendList count] > 0) {
        [_totalNumLabel setText:[NSString stringWithFormat:@"%@位联系人",count]];
        [_totalNumLabel setFrame:CGRectMake(10, 0, 300, 44)];
        
    } else {
        if ([[g_pIMMyself friends] count] > 0 ) {
            [_totalNumLabel setText:@""];
        } else {
            [_totalNumLabel setText:@"您当前还没有好友，快去添加好友吧"];
            [_totalNumLabel setCenter:CGPointMake(160, 180)];
        }
        
    }
}

- (NSMutableArray *)classifyData:(NSArray *)array {
    NSMutableArray *classificationArray = [[NSMutableArray alloc] initWithCapacity:32];
    
    array = [array sortedArrayUsingFunction:Array_sortByPinyin context:NULL];
    
    for (int i = 0; i < 26; i++) {
        [_sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    }
    
    [_sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'#']];
    
    for (NSString * customUserID in array) {
        NSString *first = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([customUserID characterAtIndex:0])] uppercaseString];
        NSString *sectionName = nil;
        
        if ([first compare:@"A"] == NSOrderedAscending || [first compare:@"Z"] == NSOrderedDescending) {
            sectionName = [NSString stringWithFormat:@"%c",'#'];
        } else {
            sectionName = first;
        }
        
        [[_sectionDic objectForKey:sectionName] addObject:customUserID];
    }
    
    for (int i = 0; i < 26; i++) {
        NSString *string = [NSString stringWithFormat:@"%c",'A' + i];
        
        NSArray *array = [_sectionDic objectForKey:string];
        
        if ([array count] > 0) {
            [classificationArray addObject:array];
            
            [_friendTitles addObject:string];
        }
    }
    
    if ([[_sectionDic objectForKey:@"#"] count] > 0) {
        [classificationArray addObject:[_sectionDic objectForKey:@"#"]];
        
        [_friendTitles addObject:@"#"];
    }
    
    return classificationArray;
}

- (void)searchUserForCustomUserID:(NSString *)searchString {
    [_searchResult removeAllObjects];
    
    [_searchResult addObjectsFromArray:[self searchSubString:searchString inArray:_friendList]];
    
}

- (NSArray *)searchSubString:(NSString *)searchString inArray:(NSArray *)sourceArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (NSArray *array in sourceArray) {
        if (![array isKindOfClass:[NSArray class]]) {
            continue;
        }
        
        for (NSString *customUserID in array) {
            if (![customUserID isKindOfClass:[NSString class]]) {
                continue;
            }
            
            NSRange range = [[customUserID uppercaseString] rangeOfString:[searchString uppercaseString]];
            
            if (range.location != NSNotFound) {
                [resultArray addObject:customUserID];
            }
            
            
        }
    }
    
    NSArray *sortArray = [resultArray sortedArrayUsingFunction:Array_sortByPinyin context:NULL];
    
    return sortArray;
}


#pragma mark - searchBar delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchUserForCustomUserID:searchString];
    return YES;
}
kRemoveCellSeparator
#pragma mark - table view datasource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return _friendTitles;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if ([_friendTitles count] <= section - 1) {
            return nil;
        }
        
        if (section == 0) {
            return nil;
        }
        
        return [_friendTitles objectAtIndex:section - 1];
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44.f;
    }
    return 70.f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if(section == 0) {
            return 0;
        }
        
        return 24.0f;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return [_friendList count] + 1;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 0) {
            return 2;
        }
        
        if ([_friendList count] <= section - 1) {
            return 0;
        }
        
        NSMutableArray *array = [_friendList objectAtIndex:section - 1];
        
        return [array count];
    }
    
    return [_searchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    NSString *cellIDV = @"cellIDV";
    NSString *customUserID = nil;
    if ([indexPath section] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (tableView == _tableView) {
        //list
        cell = [[IMContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            if ([indexPath row] == 0) {
                customUserID = @"附近商家";
            } else {
                customUserID = @"群聊";
            }
        } else {
        //search result
            if ([_searchResult count] <= [indexPath row]) {
                return cell;
            }
            customUserID = [_searchResult objectAtIndex:[indexPath row]];
        }
        [(IMContactTableViewCell *)cell setCustomUserID: customUserID];
    
        UIImage *image = nil;
    
        if ([indexPath section] == 0) {
            image = [UIImage imageNamed:@"contact_group.png"];
        } else {
            image = [g_pIMSDK mainPhotoOfUser:customUserID];
        }
    
        if (image == nil) {
            NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:customUserID];
        
            NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
            NSString *sex = nil;
        
        if ([customInfoArray count] > 1) {
            sex = [customInfoArray objectAtIndex:1];
        }
        
        if ([sex isEqualToString:@"女"]) {
            image = [UIImage imageNamed:@"IM_head_female.png"];
        } else {
            image = [UIImage imageNamed:@"IM_head_male.png"];
        }
    }
    
    [(IMContactTableViewCell *)cell setHeadPhoto:image];
    
    return cell;
}else {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDV];
     if (tableView == _tableView) {
            if (cell == nil) {
                cell = [[IMContactFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDV];
            }
            NSMutableArray *array = nil;
            
            if ([_friendList count] <= [indexPath section] - 1) {
                return cell;
            }
            
            array = [_friendList objectAtIndex:[indexPath section] - 1];
            
            if ([array count] <= [indexPath row]) {
                return cell;
            }
            
            customUserID = [array objectAtIndex:[indexPath row]];

        }
        else {
        //search result
        if ([_searchResult count] <= [indexPath row]) {
            return cell;
        }
        
        customUserID = [_searchResult objectAtIndex:[indexPath row]];
    }
    
    [(IMContactFriendsCell *)cell setCustomUserID: customUserID];
    
    UIImage *image = nil;
    
    if ([indexPath section] == 0) {
        image = [UIImage imageNamed:@"contact_group.png"];
    } else {
        image = [g_pIMSDK mainPhotoOfUser:customUserID];
    }
    
    if (image == nil) {
        NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:customUserID];
        
        NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
        NSString *sex = nil;
        
        if ([customInfoArray count] > 1) {
            sex = [customInfoArray objectAtIndex:1];
        }
        
        if ([sex isEqualToString:@"女"]) {
            image = [UIImage imageNamed:@"IM_head_female.png"];
        } else {
            image = [UIImage imageNamed:@"IM_head_male.png"];
        }
    }
    
    [(IMContactFriendsCell *)cell setHeadPhoto:image];
    
    return cell;
}
}


#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *customUserID = nil;
    
    if (_tableView == tableView) {
        if ([indexPath section] == 0) {
            if ([indexPath row] == 1) {
                IMGroupListViewController *controller = [[IMGroupListViewController alloc] init];
                
                [controller setHidesBottomBarWhenPushed:YES];
                [[self navigationController] pushViewController:controller animated:YES];
            } else {
                IMShopListViewController *controller = [[IMShopListViewController alloc] init];
                
                [controller setHidesBottomBarWhenPushed:YES];
                [[self navigationController] pushViewController:controller animated:YES];
            }
            
            return;
        }
        
        if ([_friendList count] <= [indexPath section] - 1) {
            return;
        }
        
        NSArray *array = [_friendList objectAtIndex:[indexPath section] - 1];
        
        if (![array isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if ([array count] <= [indexPath row]) {
            return;
        }

        customUserID = [array objectAtIndex:[indexPath row]];
        
        if (![customUserID isKindOfClass:[NSString class]]) {
            return;
        }
            
    } else {
        if ([_searchResult count] <= [indexPath row]) {
            return;
        }
        
        customUserID = [_searchResult objectAtIndex:[indexPath row]];
        
        if (![customUserID isKindOfClass:[NSString class]]) {
            return;
        }
    }
    
    IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
    
    [controller setCustomUserID:customUserID];
    [controller setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:controller animated:YES];
}


#pragma mark - notifications

- (void)reloadData {
    [self loadData];
}


@end
