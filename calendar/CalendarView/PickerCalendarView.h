//
//  PickerCalendarView.h
//  calendar
//
//  Created by gener on 16/12/26.
//  Copyright © 2016年 wyg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerCalendarDelegate <NSObject>

-(void)pickerCalendarSelectedWith:(NSDate*)date;

@end

@interface PickerCalendarView : UIView

@property(nonatomic,weak)id <PickerCalendarDelegate> delegate;

/*
 * show
 */
+(void)showWithDelegate:(id<PickerCalendarDelegate>)delegate;

@end
