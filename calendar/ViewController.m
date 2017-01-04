//
//  ViewController.m
//  calendar
//
//  Created by wyg on 2016/12/24.
//  Copyright © 2016年 wyg. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

#import "PickerCalendarView.h"

@interface ViewController ()<CalendarViewDelegate,PickerCalendarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CalendarView * _v = [[CalendarView alloc]initWithFrame:CGRectMake(10, 100, 300, 250)];
    _v.delegate = self;
    [self.view addSubview:_v];
}

-(void)calendarViewDidSelectedWithDate:(NSDate *)selected
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    [formatter stringFromDate:selected];
    NSLog(@"选择的日期 ： %@",[formatter stringFromDate:selected]);
}

#pragma mark - PickerCalendarDelegate

-(void)pickerCalendarSelectedWith:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    [formatter stringFromDate:date];
    NSLog(@"PickerCalendarView选择的日期 ： %@",[formatter stringFromDate:date]);
    
    _infoLable.text = [NSString stringWithFormat:@"选择的日期: %@",[formatter stringFromDate:date]];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [PickerCalendarView showWithDelegate:self];
    
}


@end
