//
//  CalendarView.h
//  calendar
//
//  Created by wyg on 2016/12/24.
//  Copyright © 2016年 wyg. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *是否显示headview,直接注释掉不显示
 */
#define NeedHeadView

/*
 *note:
 视图-height太小，可能不能正常显示
 */
#define kCalendarDefaultHeight   350

@class CalendarView;

@protocol CalendarViewDelegate <NSObject>

-(void)calendarViewDidSelectedWithDate:(NSDate*)date;

@end

@interface CalendarView : UIView

@property (nonatomic, weak)id<CalendarViewDelegate>delegate;

@end






