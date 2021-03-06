//
//  JYConsts.h
//  SimplEasy
//
//  Created by EvenLam on 15/11/3.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//


#ifndef JYConsts_h
#define JYConsts_h

#ifdef DEBUG
#define JYLog(...) NSLog(__VA_ARGS__)
#else
#define JYLog(...)
#endif


/**  数据 */
//第一个轮播图的高
#define firstLVH 116
//第二个轮播图的高
#define secondLVH 30

//sms
#define SMSAppKey @"cbdfe5047f95"
#define SMSAppSecret @"c286cc3b00b6b7d29a53fc571e704036"

//友盟分享唯一appKey
#define UmengAppKey @"5656f05d67e58ea1f0001977"

#define WXAppKey @"wxf130f68d1a77dc4d"
#define WXAppSecret @"d4624c36b6795d1d99dcf0547af5443d"

#define QQAppID @"1104918521"
#define QQAppKey @"3UIjffKw1QNpnbfh"

#define WBAppKey @"1321061525"
#define WBAppSecret @"009a3587486610af8430e71a767234f4"

/**  nslog */
#define YSHLog(...) NSLog(__VA_ARGS__)
/** 通过RGB设置颜色 */
#define kRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
//背景颜色 首页 webview
#define YSHGlobalBg kRGBColor(230, 230, 230)
//绿色
#define JYGlobalBg kRGBColor(71, 163, 105)

//略白
#define JYWhite kRGBColor(250, 250, 250)
//线条颜色 灰色
#define JYLineColor kRGBColor(217, 217, 217)
//注册页button 黑色
#define JYButtonColor kRGBColor(39, 43, 52)

/** 十六进制转换颜色,需要写0x前缀 */
#define JYHexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//url前缀
#define JYURL @"http://wx.i-jianyi.com"

/** 应用程序的屏幕高度 */
#define kWindowH   [UIScreen mainScreen].bounds.size.height
/** 应用程序的屏幕宽度 */
#define kWindowW    [UIScreen mainScreen].bounds.size.width

#define loginVC [JYLoginViewController shareLoginVC]

#define rootVC [JYRootViewController shareRootVC]

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
#define kLibraryPath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject

#endif /* JYConsts_h */
