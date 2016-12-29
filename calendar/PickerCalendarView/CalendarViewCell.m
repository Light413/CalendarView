//
//  CalendarViewCell.m
//  calendar
//
//  Created by wyg on 2016/12/24.
//  Copyright © 2016年 wyg. All rights reserved.
//

#import "CalendarViewCell.h"

@implementation CalendarViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = [[UILabel alloc]init];
        _title.backgroundColor = [UIColor whiteColor];
        _title.textColor = [UIColor blackColor];
        _title.translatesAutoresizingMaskIntoConstraints = NO;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:itemCellFontSize];
        [self addSubview:_title];

    }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    _title.backgroundColor = [UIColor whiteColor];
    _title.textColor = [UIColor blackColor];
    self.tag = 0;
}

-(void)layoutSubviews
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_title]|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_title)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_title]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_title)]];
}

@end
