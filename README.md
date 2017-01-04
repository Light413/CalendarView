##CalendarView
A simple use for iOS Calendar - select date when pop -up。(demo for Xcode8.0 , ios10 ,ARC) 。   


![CalendarView](https://raw.githubusercontent.com/Light413/images/master/CalendarView_demo.gif)

### Adding to your project

use pod : <br>
 
```
pod 'PickerCalendarView', '~> 1.0.0'
```
not pod : <br> 
download the demo , pull \`PickerCalendarView folder \` into your project. <br>
 
 
### only use \`CalendarView\` :

```
CalendarView * _v = [[CalendarView alloc]initWithFrame:CGRectMake(10, 100, 300, 250)];
    _v.delegate = self;
    [self.view addSubview:_v];    
```

as follows: <hr>
![CalendarView](https://raw.githubusercontent.com/Light413/images/master/CalendarView_base.png)

if you think the headview isn't right ,you can hide it in file `CalendarView.h` ,just like  this<br>

```
//#define NeedHeadView
```
and add custom .

### use pop-up function:

 ```
 [PickerCalendarView showWithDelegate:self];
 ```
you should implement it's delegate mothods for get data. 
that is all , just see code.

