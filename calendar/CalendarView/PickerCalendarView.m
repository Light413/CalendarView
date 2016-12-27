//
//  PickerCalendarView.m
//  calendar
//
//  Created by gener on 16/12/26.
//  Copyright © 2016年 wyg. All rights reserved.
//

#import "PickerCalendarView.h"
#import "CalendarView.h"

@interface PickerCalendarView ()<CalendarViewDelegate>
{
    CalendarView * _calendarView;
}

@end

@implementation PickerCalendarView

-(instancetype)init
{
    self = [super init];
    if (self) {
        _calendarView = [[CalendarView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen]bounds]), CGRectGetWidth([[UIScreen mainScreen]bounds]), 250)];
        _calendarView.delegate = self;
        self.frame = [[UIScreen mainScreen]bounds];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.4;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

+(void)showWithDelegate:(id<PickerCalendarDelegate>)delegate
{
    [[[self alloc]init]showWithDelegate:delegate];
}

-(void)showWithDelegate:(id<PickerCalendarDelegate>)delegate
{
    self.delegate = delegate;
    UIWindow * keywindow = [[UIApplication sharedApplication]keyWindow];
    [keywindow addSubview:self];
    [keywindow addSubview:_calendarView];
    
    [UIView animateWithDuration:0.25 animations:^{
        _calendarView.frame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen]bounds])-350, CGRectGetWidth([[UIScreen mainScreen]bounds]), 350);
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        _calendarView.frame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen]bounds]), CGRectGetWidth([[UIScreen mainScreen]bounds]), 350);
    } completion:^(BOOL finished) {
        [_calendarView removeFromSuperview];
        _calendarView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark - CalendarViewDelegate
-(void)calendarViewDidSelectedWithDate:(NSDate *)date
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerCalendarSelectedWith:)]) {
        [self.delegate performSelector:@selector(pickerCalendarSelectedWith:) withObject:date];
    }
    
    [self dismiss];
}


@end
