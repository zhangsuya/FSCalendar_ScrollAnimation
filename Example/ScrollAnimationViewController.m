//
//  ScrollAnimationViewController.m
//  FSCalendar
//
//  Created by suya on 15/12/10.
//  Copyright © 2015年 wenchaoios. All rights reserved.
//

#import "ScrollAnimationViewController.h"
#import "UIView+MLExtension.h"
#import "NSDate+FSExtension.h"

@interface ScrollAnimationViewController ()
{
    NSString *locationString;
    NSString *weekForSection;
}
@end

@implementation ScrollAnimationViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"FSCalendar";
    }
    return self;
}
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
    self.view = view;
    [self initCalendar];//日历控件初始化
    [self initTableView];//日历控件下面的TableView的初始化
    //当天日期
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    locationString=[dateformatter stringFromDate:[NSDate date]];
    [self initSectionDate];//tableview section显示的日期
}
- (void)viewDidLoad {
    [super viewDidLoad];
#if 0
    FSCalendarTestSelectDate
#endif
    
    // Do any additional setup after loading the view.
}
-(void)initCalendar
{
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 300)];
    calendar.firstWeekday = 1;
    calendar.delegate = self;
    calendar.dataSource =self;
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    
    [self.view addSubview:calendar];
    self.calendar = calendar;
}
-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 365, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.backgroundColor = viewBgColor;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
-(void)initSectionDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSUInteger week = [comps weekday];
    switch (week) {
        case 2:
            weekForSection =[NSString stringWithFormat:@"%@",@"星期一"];
            break;
        case 3:
            weekForSection =[NSString stringWithFormat:@"%@",@"星期二"];
            break;
        case 4:
            weekForSection =[NSString stringWithFormat:@"%@",@"星期三"];
            break;
        case 5:
            weekForSection =[NSString stringWithFormat:@"%@",@"星期四"];
            break;
        case 6:
            weekForSection =[NSString stringWithFormat:@"%@",@"星期五"];
            break;
        case 7:
            weekForSection =[NSString stringWithFormat:@"%@",@"星期六"];
            break;
        case 1:
            weekForSection =[NSString stringWithFormat:@"%@",@"星期天"];
            break;
        default:
            break;
    }

}
//FSCalendarDataSource, FSCalendarDelegate
- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    CGSize size = [calendar sizeThatFits:calendar.frame.size];
    _calendar.ml_height = size.height;
    self.tableView.ml_y = size.height+1+64;

}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"did select date %@",[date fs_stringWithFormat:@"yyyy/MM/dd"]);
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[obj fs_stringWithFormat:@"yyyy/MM/dd"]];
    }];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    locationString=[dateformatter stringFromDate:date];
    [self initSectionDate];
    [self.tableView reloadData];
    NSLog(@"selected dates is %@",selectedDates);
    
}
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date
{
    NSLog(@"should select date %@",[date fs_stringWithFormat:@"yyyy/MM/dd"]);
    return YES;
}


- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    
    NSLog(@"did change to page %@",[calendar.currentPage fs_stringWithFormat:@"MMMM yyyy"]);
}

- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date
{

    return [UIImage imageNamed:@"calendar_circle_r.pdf"];
    
}
//tableviewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 25)];
        sectionView.backgroundColor = viewBgColor;
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,kDeviceWidth - 16, 25)];
        sectionLabel.text = [NSString stringWithFormat:@"%@月%@日 %@",[locationString substringWithRange:NSMakeRange(5, 2)],[locationString substringWithRange:NSMakeRange(8, 2)],weekForSection];
        sectionLabel.textColor = placehoderFontColor;
        [sectionLabel setFont: [UIFont systemFontOfSize:12]];
        [sectionView addSubview:sectionLabel];
        return sectionView;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.text = [NSString stringWithFormat:@"suya make scrollView%ld",(long)indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
//滚动效果在这里
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        NSLog(@"%@",@(scrollView.contentOffset.y));
        if (_calendar.ml_height >= 300) {
            if (scrollView.contentOffset.y <=0) {
                
                
                FSCalendarScope selectedScope =  FSCalendarScopeMonth ;
                
                [_calendar setScope:selectedScope animated:YES];
                
                
                
            }else
            {//tableview向上滚动，则日历显示一周的
                
                FSCalendarScope selectedScope =  FSCalendarScopeWeek ;
                
                [_calendar setScope:selectedScope animated:YES];
                
                
                
            }
            
        }else
        {
            if (scrollView.contentOffset.y >=0) {
                
                
                FSCalendarScope selectedScope =  FSCalendarScopeWeek ;
                
                [_calendar setScope:selectedScope animated:YES];
                
                
                
            }else
            {//tableview向下滚动，则日历显示一个月的
                FSCalendarScope selectedScope =  FSCalendarScopeMonth ;
                
                [_calendar setScope:selectedScope animated:YES];
                
                
                
            }
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
