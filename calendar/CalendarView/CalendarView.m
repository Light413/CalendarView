//
//  CalendarView.m
//  calendar
//
//  Created by wyg on 2016/12/24.
//  Copyright © 2016年 wyg. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarViewCell.h"

static NSString * calendarCollectionCellIdentifier = @"calendarCollectionCellIdentifier";
@interface CalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * _collectionView;
    NSCalendar * _calendar;
    
    NSDate * _currentDate; //当前选择的日期
    NSInteger _currentYear;//当前选择的年份
    NSInteger _currentMonth;//当前选择的月份
    NSInteger _currentMonthFirstDay;//当前月份的第一天
    NSInteger _currentMonthTotalDays;//当前月份总天数
    
    //现在实际的日期
    NSInteger _nowDay;
    NSInteger _nowMonth;
    NSInteger _nowYear;
    NSInteger _lastMonthDays;//上个月的总天数
}
@end

@implementation CalendarView

-(instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame),CGRectGetWidth(frame), CGRectGetHeight(frame)>=kCalendarDefaultHeight?CGRectGetHeight(frame):kCalendarDefaultHeight);
    if (self = [super initWithFrame:frame]) {
        [self initSubview:frame];
        [self initData];
    }
    return self;
}

-(void)initData
{
    _currentDate = [NSDate date];
    _calendar = [NSCalendar currentCalendar];
    NSDateComponents * component = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_currentDate];
    _currentYear = component.year;
    _currentMonth = component.month;
    _nowDay = component.day;
    _nowMonth = component.month;
    _nowYear = component.year;
    
    [self getCurrentData];
}

-(void)getCurrentData
{
    _lastMonthDays = [self totalDayOfLastMonth];
    _currentMonthFirstDay = [self firstDayOfMonth:_currentDate];
    _currentMonthTotalDays = [self totalDayOfMonth:_currentDate];
    
    UILabel * _l = [[self viewWithTag:10] viewWithTag:102];
    _l.text = [NSString stringWithFormat:@"%ld - %02ld",_currentYear,_currentMonth];
}

-(void)initSubview:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *_v = [self addHeadView];
    CGFloat WIDTH = (CGRectGetWidth(frame))/7.0;
    NSArray * titleArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    UIView * bgTitleview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_v.frame), CGRectGetWidth(frame), 20)];
    [self addSubview:bgTitleview];
    for (int i =0; i < 7; i++) {
        UILabel * l = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, CGRectGetHeight(bgTitleview.frame))];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = titleArr[i];
        l.textColor = [UIColor darkGrayColor];
        l.font = [UIFont systemFontOfSize:12];
        [bgTitleview addSubview:l];
    }
    
    UICollectionViewFlowLayout * _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.itemSize = CGSizeMake((CGRectGetWidth(frame) - 0)/7.0, (CGRectGetHeight(frame) - CGRectGetMaxY(bgTitleview.frame))/6.0);
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgTitleview.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetMaxY(bgTitleview.frame)) collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CalendarViewCell class] forCellWithReuseIdentifier:calendarCollectionCellIdentifier];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
    self.layer.borderColor = [UIColor greenColor].CGColor;
    self.layer.borderWidth = 0.6;
}

-(UIView*)addHeadView
{
    #ifdef NeedHeadView
    CGFloat _height = 50.0;
    CGFloat _textFontSize = 16.0;
    
    UIView * bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), _height)];
    bgview.tag = 10;
    [self addSubview:bgview];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"上月" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgview addSubview:leftBtn];
    leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:_textFontSize];
    [leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 100;
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"下月" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgview addSubview:rightBtn];
    rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:_textFontSize];
    [rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 101;
    
    UIButton * todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayBtn setTitle:@"今天" forState:UIControlStateNormal];
    [todayBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bgview addSubview:todayBtn];
    todayBtn.translatesAutoresizingMaskIntoConstraints = NO;
    todayBtn.titleLabel.font = [UIFont systemFontOfSize:_textFontSize];
    [todayBtn addTarget:self action:@selector(todayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
     UILabel *_dispDateLab = [[UILabel alloc]init];
    _dispDateLab.translatesAutoresizingMaskIntoConstraints = NO;
    _dispDateLab.font = [UIFont systemFontOfSize:16];
    _dispDateLab.textAlignment = NSTextAlignmentCenter;
    _dispDateLab.tag = 102;
    [bgview addSubview:_dispDateLab];
    
    NSArray * _v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftBtn(_height)]" options:NSLayoutFormatAlignAllTop metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(_height),@"_height", nil] views:NSDictionaryOfVariableBindings(leftBtn)];
    NSArray * _h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[leftBtn(60)]-[_dispDateLab(100)]-[rightBtn(==leftBtn)]-[todayBtn]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(leftBtn,rightBtn,_dispDateLab,todayBtn)];
    [bgview addConstraints:_v];
    [bgview addConstraints:_h];
//    [bgview addConstraint:[NSLayoutConstraint constraintWithItem:bgview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_dispDateLab attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    return bgview;

    #else
        return nil;
    #endif
}

#pragma mark - Button action
//选择今天日期
-(void)todayButtonClick :(UIButton*)btn
{
    _currentYear = _nowYear;
    _currentMonth = _nowMonth;
    _currentDate = [NSDate date];
    
    [self getCurrentData];
    [_collectionView reloadData];
    
    NSDate * selected = [self dateComponentFromYear:_nowYear month:_nowMonth andDay:_nowDay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarViewDidSelectedWithDate:)]) {
        [self.delegate calendarViewDidSelectedWithDate:selected];
    }
}

//切换选择月份
-(void)buttonClick:(UIButton*)button
{
    NSDateComponents * nowComponent = [[NSDateComponents alloc]init];
    if (button.tag == 100) {
        //last
        _currentMonth==1?({_currentMonth = 12;_currentYear--;}):_currentMonth--;
    }
    else if (button.tag == 101)
    {//next
        _currentMonth==12?({_currentMonth = 1;_currentYear++;}):_currentMonth++;
    }
    
    nowComponent.year = _currentYear;
    nowComponent.month = _currentMonth;
    nowComponent.day = 1;
    _currentDate = [_calendar dateFromComponents:nowComponent];
    
    [self getCurrentData];
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:calendarCollectionCellIdentifier forIndexPath:indexPath];
    
    NSInteger startDay = _currentMonthFirstDay;
    NSInteger totalDay = _currentMonthTotalDays;
    NSInteger value =0,tag =0;
    BOOL thisMonth = NO,thisDay = NO;
    
    //上个月天数
    if (indexPath.row < startDay-1) {
        value = _lastMonthDays+1 - (startDay - indexPath.row - 1);
        tag = 100 + value;
    }
    //本月天数
    else if ((indexPath.row > (startDay-2)) &&(indexPath.row < totalDay + startDay-1) ) {
        thisMonth = YES;
        value = indexPath.row - (startDay-2);
        tag = 200 + value;
        if (value == _nowDay && _currentYear == _nowYear && _currentMonth == _nowMonth) {
            thisDay = YES;
            cell.title.backgroundColor = [UIColor redColor];
            cell.title.textColor = [UIColor whiteColor];
        }
    }
    //下个月天数
    else if (indexPath.row > totalDay + startDay-2) {
        value = indexPath.row - totalDay- startDay+2;
        tag = 300 + value;
    }

    if (!thisMonth || (!thisDay && (indexPath.row%7 == 0 || indexPath.row%7 == 6))) {
       cell.title.textColor = [UIColor lightGrayColor];
    }
    
    cell.title.text = [NSString stringWithFormat:@"%ld",value];
    cell.tag = tag;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger year,month,day;
    CalendarViewCell * cell = (CalendarViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger tag = cell.tag;

    switch (tag / 100) {
        case 1://1.选择的是上一个月的日期
            if (_currentMonth == 1) {
                month = 12;
                year = _currentYear - 1;
            }
            else
            {
                month = _currentMonth - 1;
                year = _currentYear;
            }
                day = tag%100;
            break;
        case 2://2.选择的是当月的日期
                month = _currentMonth;
                year = _currentYear;
                day = tag%200;
            break;
        case 3://3.选择的是下一个月的日期
            if (_currentMonth == 12) {
                month = 1;
                year = _currentYear + 1;
            }
            else
            {
                month = _currentMonth + 1;
                year = _currentYear;
            }
            day = tag%300;
            break;
        default:break;
    }
    
    NSDate * selected = [self dateComponentFromYear:year month:month andDay:day];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarViewDidSelectedWithDate:)]) {
        [self.delegate calendarViewDidSelectedWithDate:selected];
    }
}

#pragma mark - date methods
-(NSDate*)dateComponentFromYear:(NSInteger)year month:(NSInteger)month andDay:(NSInteger)day
{
    NSDateComponents * comp = [[NSDateComponents alloc]init];
    comp.year = year;
    comp.month = month;
    comp.day = day;
    return [_calendar dateFromComponents:comp];
}

-(NSInteger)firstDayOfMonth:(NSDate *)date
{
    NSDateComponents * component = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    component.day = 1;
    
    NSDate * newDate = [_calendar dateFromComponents:component];
    
    return [_calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
}

-(NSInteger)totalDayOfMonth:(NSDate *)date
{
    return [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

//上个月总天数
-(NSInteger)totalDayOfLastMonth
{
    NSDateComponents * comp = [[NSDateComponents alloc]init];
    if (_currentMonth ==1) {
        comp.year = _currentYear - 1;
        comp.month = 12;
    }
    else
    {
        comp.year = _currentYear;
        comp.month = _currentMonth - 1;
    }
    comp.day = 1;
    
    return [self totalDayOfMonth:[_calendar dateFromComponents:comp]];
}


@end
