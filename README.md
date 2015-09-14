# WeCalICS For iOS

ics文件的解析和封装

## 解析

``` objective-c
NSString *icsFilePath = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"ics"];
NSString* content = [[NSString alloc] initWithContentsOfFile:icsFilePath encoding:NSUTF8StringEncoding error:nil];
//单个解析
[[WCCalHelper shareICALHelper] paraserICALWithString:ss  paraserFinished:^(NSArray *events) {        
    for (WCEvent* event in events) {
        NSLog(@"%@",event.summary);
    }
}];
//批量解析
[[WCCalHelper shareICALHelper] batchParaserICALContent:@[content,content,content,content,content] paraserFinished:^(NSArray *events) {
    for(WCEvent* event in events){
        NSLog(@"%@",event.summary);
    }
} paraserAllFinished:^(BOOL sucess) {    
    if(sucess){
        NSLog(@"所有的ics文件解析结束");
    }
}];
```



## 生成(添加)

``` objective-c
//创建calendar
WCCalendar* calendar = [WCCalendar wc_makeCalendar:^(WCCalendarMaker *maker) {
    [maker addEventWithBlock:^(WCEventMaker *maker) {

        maker.dateStart = [NSDate date];
        maker.dateEnd = [[NSDate date] dateByAddingTimeInterval:24 * 60 * 60];
        maker.summary = @"标题1";
        maker.desc = @"描述1";
        maker.location = @"地点1";
    }];

    [maker addEventWithBlock:^(WCEventMaker *maker) {
        maker.dateStart = [NSDate date];
        maker.dateEnd = [[NSDate date] dateByAddingTimeInterval:24 * 60 * 60];
        maker.summary = @"标题2";
        maker.desc = @"描述2";
        maker.location = @"地点2";
    }];
}];
NSLog(@"%@",[calendar stringSerializeComponent]);
//打印结果
BEGIN:VCALENDAR
METHOD:REQUEST
VERSION:2.0
PRODID:-//RDU Software//NONSGML HandCal//EN
BEGIN:VEVENT
DTSTART:20150810T081547Z
DTEND:20150811T081547Z
SUMMARY:标题1
DESCRIPTION:描述1
UID:9206E0DB-0210-4130-BA3B-4B36A71F326A
END:VEVENT
BEGIN:VEVENT
DTSTART:20150810T081547Z
DTEND:20150811T081547Z
SUMMARY:标题2
DESCRIPTION:描述2
UID:AE91660A-9ACE-44A3-BAE0-E418E615F13F
END:VEVENT
END:VCALENDAR
```

## 修改

``` objective-c
//修改calendar
WCCalendar*  calendar = [WCCalendar calendarWithString:ss];
[WCCalendar wc_updateCalendar:calendar block:^(WCCalendarMaker *maker) {
      [maker updateEventWithBlock:@"69A68215-F94B-4A23-8BB2-CF118B8FA0D5" 		block:^(WCEventMaker *maker) {
          maker.summary = @"Hello World";
      }];
      [maker updateEventWithBlock:@"3DB59CD1-0726-4772-8286-BD5AF82E97D3" block:^(WCEventMaker *maker) {
          maker.summary = @"BEN";
      }];
}];
NSLog(@"%@",[calendar stringSerializeComponent]);
//打印结果:
BEGIN:VCALENDAR
METHOD:REQUEST
VERSION:2.0
PRODID:-//RDU Software//NONSGML HandCal//EN
BEGIN:VEVENT
DTSTART:20150810T043731Z
DTEND:20150811T043731Z
SUMMARY:标题1
DESCRIPTION:描述1
UID:69A68215-F94B-4A23-8BB2-CF118B8FA0D5
SUMMARY:Hello World
END:VEVENT
BEGIN:VEVENT
DTSTART:20150810T043731Z
DTEND:20150811T043731Z
SUMMARY:标题2
DESCRIPTION:描述2
UID:3DB59CD1-0726-4772-8286-BD5AF82E97D3
SUMMARY:BEN
END:VEVENT
END:VCALENDAR
```
