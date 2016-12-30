##CalendarView
<hr>
A simple use for iOS Calendar - select date when pop -up。(Xcode8.0 , ios10 ,ARC) 。   
   
as follows<br>

![CalendarView](https://raw.githubusercontent.com/Light413/images/master/CalendarView_demo.gif)

###Usage
 
first download the demo , pull `PickerCalendarView folder ` into your project.

* ### only use `CalendarView` ,eg:

```
    CalendarView * _v = [[CalendarView alloc]initWithFrame:CGRectMake(10, 100, 300, 250)];
    _v.delegate = self;
    [self.view addSubview:_v];
```
as follows: <hr>
![CalendarView](https://raw.githubusercontent.com/Light413/images/master/CalendarView_base.png)

if you think the headview isn't for,you can hide it in file `CalendarView.h` ,just like  this<br>

```
//#define NeedHeadView
```
and add yourself.

* ### use pop-up :

 ```
 [PickerCalendarView showWithDelegate:self];
 
 ```

you should implement it's delegate mothods for get data. <br>

that is all,nothing want to say,see code.

