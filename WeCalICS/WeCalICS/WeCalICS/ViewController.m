//
//  ViewController.m
//  WeCalICS
//
//  Created by zhipeng ben on 10/8/2015.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import "ViewController.h"
#import "WCCal.h"

//#define DebugModel

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    NSMutableArray* tmp = [[NSMutableArray alloc] init];
//    for(NSInteger i = 0; i < 2; i++){
//        NSDictionary* dic = @{@"name":@"ben",@"email":@"11@11.com"};
//        [tmp addObject:dic];
//    }
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmp options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"json data:%@",json);
//    
    NSString *icsFilePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"ics"];
    NSString* ss = [[NSString alloc] initWithContentsOfFile:icsFilePath encoding:NSUTF8StringEncoding error:nil];
//
    [WCCalendar calendarParaser:ss events:^(NSArray *events) {
        WCEvent* event = events.firstObject;
        NSLog(@"%@",@"111");
    }];
//
//    
////
////#ifdef DebugModel
////    WCEventDebugModel = 1;
////#endif
////
//    
    WCCalendar* newCalendar = [WCCalendar wc_makeCalendar:^(WCCalendarMaker *maker) {
        
        [maker addEventWithBlock:^(WCEventMaker *maker) {
            
            maker.dateStart = [NSDate date];
            maker.dateEnd = [[NSDate date] dateByAddingTimeInterval:24 * 60 * 60];
            maker.dateCreated = [[NSDate date] dateByAddingTimeInterval:24 * 2 * 60 * 60];
            maker.dateLastModified = [[NSDate date] dateByAddingTimeInterval:24 * 3 * 60 * 60];
            maker.summary = @"标题1";
            maker.desc = @"描述1";
            
            WCLocation* location = [WCLocation lon:23.90 lat:34.05 des:@"地点44444" url:nil];
            location.x_wc_location = @{@"city":@"江苏",@"area":@"雨花台区"};
            location.geo.lon = 45.0;
            location.geo.lat = 27.0;
            maker.locationExt = location;
            maker.url = @"http://www.baidu.com";
            maker.status = @"CONFIRMED";
            
            WCPerson* person1 = [WCPerson personWithEmailAndName:@"11@qq.com" name:@"BEN"];
            person1.x_wc_person = @{@"person_display_name":@"BEN",@"person_email":@"11@qq.com"};;
            person1.role = @"CHAIR";
            person1.partstat = @"TENTATIVE";
            
            WCPerson* person2 = [[WCPerson alloc] init];
            person2.name = @"CAO";
            person2.email = @"22@qq.com";
            person2.x_wc_person = @{@"person_display_name":@"CAO",@"person_email":@"22@qq.com"};;
            maker.attendees = @[person1,person2];
           
            maker.isRing = 1;
            maker.advance = @"2,4,5";
        }];
        
    }];

    NSLog(@"%@",[newCalendar stringSerializeComponent]);
//
    [WCCalendar calendarParaser:[newCalendar stringSerializeComponent] events:^(NSArray *events) {
        WCEvent* event = events.firstObject;
        NSLog(@"%@",@"111");
    }];
////
//
//    WCCalendar* calendar = [WCCalendar calendarParaser:ss events:^(NSArray *events) {
//       
//
//    }];
//    WCCalendar* calendar = [WCCalendar calendarWithString:ss];
//    
//    NSString* xx =  [calendar stringSerializeComponent];
//    NSLog(@"%@",xx);
    
    
//    [calendar wc_updateCalendar:^(WCCalendarMaker *maker) {
//        [maker updateEventWithBlock:@"76451e8a-54e0-4163-aedd-cbb87e5ef37f" block:^(WCEventMaker *maker) {
//            maker.isAllDay = 1;
//        }];
//    }];
//    
//    NSLog(@"%@",[calendar stringSerializeComponent]);
//    
////    
//    WCCalendar *calendar = [WCCalendar wc_makeCalendar:^(WCCalendarMaker *maker) {
//       
//        [maker addEventWithBlock:^(WCEventMaker *maker) {
//           
//            maker.dateStart = [NSDate date];
//            maker.dateEnd = [[NSDate date] dateByAddingTimeInterval:24 * 60 * 60];
//            maker.dateCreated = [NSDate date];
//            maker.dateLastModified = [NSDate date];
//            maker.summary = @"1";
//            maker.isAllDay = 1;
//            
//        }];
//    }];
//    
//    NSLog(@"%@",[calendar stringSerializeComponent]);
    
//    //单个解析
//
//     [WCCalendar calendarParaser:ss events:^(NSArray *events) {
//        WCEvent* event = events[0];
//        
//        if([event locationIsURLValueKind]){
//            NSLog(@"111");
//        }
//        
//        [event wc_updateEvent:^(WCEventMaker *maker) {
//           
//
//        }];
//        
//    }];
    
//    
//    icalproperty* p = icalproperty_new_cmd(ICAL_CMD_GENERATEUID);
//    NSString* xx = [NSString stringWithCString:icalproperty_as_ical_string(p) encoding:NSUTF8StringEncoding];
    
//    [[WCCalHelper shareICALHelper] paraserICALWithString:ss  paraserFinished:^(NSArray *events) {
//        
//        for (WCEvent* event in events) {
//            NSLog(@"%@",event.summary);
////            NSLog(@"%@",event.rrule);
//        }
//    }];
    
//    //创建calendar
   
//
//
    
    WCEvent* event = ((WCEvent*)[[newCalendar subcomponents] firstObject]);
    [event read];
    NSString* uuid = event.UID;
    WCCalendar* modiCalendar = [WCCalendar calendarWithString:[newCalendar stringSerializeComponent]];
    [modiCalendar wc_updateCalendar:^(WCCalendarMaker *maker) {
        [maker updateEventWithBlock:uuid block:^(WCEventMaker *maker) {
           maker.summary = @"111";
//            WCPerson* person1 = [WCPerson personWithEmailAndName:@"11@qq.com" name:@"BEN"];
//            person1.x_wc_person = @{@"person_display_name":@"BEN",@"person_email":@"11@qq.com"};;
//            person1.role = @"CHAIR";
//            person1.partstat = @"TENTATIVE";
//            
//            WCPerson* person2 = [[WCPerson alloc] init];
//            person2.name = @"CAO";
//            person2.email = @"22@qq.com";
//            person2.x_wc_person = @{@"person_display_name":@"CAO",@"person_email":@"22@qq.com"};;
            maker.attendees = nil;

            
//            WCLocation* location = [WCLocation lon:23.90 lat:34.05 des:@"地点" url:nil];
//            location.x_wc_location = @{@"city":@"北京",@"area":@"朝阳区"};
            maker.locationExt = nil;
            
            maker.isRing = 0;
            maker.advance = @"3";
        }];
    }];
    NSLog(@"%@",[modiCalendar stringSerializeComponent]);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
