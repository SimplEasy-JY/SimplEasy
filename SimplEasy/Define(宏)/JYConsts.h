//
//  JYConsts.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//


#ifndef JYConsts_h
#define JYConsts_h
/**  nslog */
#define YSHLog(...) NSLog(__VA_ARGS__)
/** 通过RGB设置颜色 */
#define kRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

/** 应用程序的屏幕高度 */
#define kWindowH   [UIScreen mainScreen].bounds.size.height
/** 应用程序的屏幕宽度 */
#define kWindowW    [UIScreen mainScreen].bounds.size.width

#define kAppDelegate ((AppDelegate*)([UIApplication sharedApplication].delegate))

#define kStoryboard(StoryboardName)     [UIStoryboard storyboardWithName:StoryboardName bundle:nil]

/** 通过Storyboard ID 在对应Storyboard中获取场景对象 */
#define kVCFromSb(VCID, SbName)     [[UIStoryboard storyboardWithName:SbName bundle:nil] instantiateViewControllerWithIdentifier:VCID]

/** 移除iOS7之后，cell默认左侧的分割线边距 */
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\

/** Docment文件夹目录 */
#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#endif /* JYConsts_h */
