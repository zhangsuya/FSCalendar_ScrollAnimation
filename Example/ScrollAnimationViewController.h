//
//  ScrollAnimationViewController.h
//  FSCalendar
//
//  Created by suya on 15/12/10.
//  Copyright © 2015年 wenchaoios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
//当前设备的宽高
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
//uiview背景颜色
#define viewBgColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
#define placehoderFontColor [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1]
@interface ScrollAnimationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, FSCalendarDataSource, FSCalendarDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,weak)FSCalendar *calendar;
@end
