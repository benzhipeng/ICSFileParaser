//
//  WCCalMaker.m
//  WCIcs
//
//  Created by zhipeng ben on 10/8/2015.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import "WCCalMaker.h"
#import "WCEvent.h"
#import "WCCalendar.h"

NSInteger WCEventDebugModel = 0;
NSString*  CALENDAR_Property_Version = @"2.0";
NSString*  CALENDAR_Property_Provide = @"-//RDU Software//NONSGML HandCal//EN";
NSString*  CALENDAR_Property_Method = @"REQUEST";

@interface WCEventMaker ()
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,strong) WCEvent*  wcEvent;
@end

@implementation WCEventMaker
- (WCEvent*)make{
    
    if (WCEventDebugModel){
        NSAssert(_summary && _summary.length > 0, @"标题不可以为空");
        NSAssert(_dateStart, @"开始时间不可以为空");
        NSAssert(_dateEnd, @"结束时间不可以为空");
        NSAssert(_dateCreated, @"创建时间不可以为空");
        NSAssert(_dateLastModified, @"最后修改时间不可以为空");
    }
    
    WCEvent* event = [[WCEvent alloc] init];
    event.isAllDay = _isAllDay;
    event.dateStart = _dateStart;
    event.dateEnd = _dateEnd;
    event.summary = _summary;
    event.desc = _desc ? _desc : @"";
    event.locationExt = _locationExt;
    event.status = _status ? _status : @"CONFIRMED";
    event.url = _url ? _url : @"";
    event.attendees = _attendees;
    event.kind = ICAL_VEVENT_COMPONENT;
    event.rrule = _rrule;
    event.dateCreated = _dateCreated;
    event.dateLastModified = _dateLastModified;
    event.advance = _advance;
    event.isRing = _isRing;
    event.UID = [NSString stringWithFormat:@"%@%@",[[[NSUUID UUID] UUIDString] lowercaseString],@"@ecloud.im"];
    return event;
}

- (void)update:(WCEvent*)event{
    self.isEdit = YES;
    self.wcEvent = event;
}


- (void)setSummary:(NSString *)summary{
    if(self.isEdit){
        NSAssert(summary && summary.length > 0, @"标题不可以为空");
        self.wcEvent.summary = summary;
    }else {
        _summary = summary;
    }
}
- (void)setDesc:(NSString *)desc{
    if(self.isEdit){
        self.wcEvent.desc = desc ? desc : @"";
    }else {
        _desc = desc;
    }
}


- (void)setDateStart:(NSDate *)dateStart{
    if(self.isEdit){
        NSAssert(dateStart, @"开始时间不可以为空");
        self.wcEvent.isAllDay = _isAllDay;
        self.wcEvent.dateStart = dateStart;
    }else {
        _dateStart = dateStart;
    }
}

- (void)setDateEnd:(NSDate *)dateEnd{
    if(self.isEdit){
        NSAssert(dateEnd, @"结束时间不可以为空");
        self.wcEvent.isAllDay = _isAllDay;
        self.wcEvent.dateEnd = dateEnd;
    }else {
        _dateEnd = dateEnd;
    }
}

- (void)setDateCreated:(NSDate *)dateCreated{
    if(self.isEdit){
//        NSAssert(dateCreated, @"创建时间不可以为空");
        self.wcEvent.dateCreated = dateCreated;
    }else {
        _dateCreated = dateCreated;
    }
}

- (void)setDateLastModified:(NSDate *)dateLastModified{
    if(self.isEdit){
//        NSAssert(dateLastModified, @"开始时间不可以为空");
        self.wcEvent.dateLastModified = dateLastModified;
    }else {
        _dateLastModified = dateLastModified;
    }
}

- (void)setIsAllDay:(BOOL)isAllDay{
    if(self.isEdit){
        self.wcEvent.isAllDay = isAllDay;
    }else {
        _isAllDay = isAllDay;
    }
}

- (void)setRrule:(WCRecurrenceRule *)rrule{
    if(self.isEdit){
        self.wcEvent.rrule = rrule;
    }else {
        _rrule = rrule;
    }
}

- (void)setUrl:(NSString *)url{
    if(self.isEdit){
        self.wcEvent.url = url ? url : @"";
    }else {
        _url = url;
    }
}

- (void)setStatus:(NSString *)status{
    if(self.isEdit){
        self.wcEvent.status = status ? status : @"TENTATIVE";
    }else {
        _status = status;
    }
}

- (void)setAttendees:(NSArray *)attendees{
    if(self.isEdit){
        self.wcEvent.attendees = attendees;
    }else {
        _attendees = attendees;
    }
}

- (void)setLocationExt:(WCLocation *)locationExt{
    if(self.isEdit){
        self.wcEvent.locationExt = locationExt;
    }else {
        _locationExt = locationExt;
    }
}

- (void)setAdvance:(NSString *)advance{
    if(self.isEdit){
        self.wcEvent.advance = advance ? advance : @"";
    }else {
        _advance = advance ? advance : @"";
    }
}

- (void)setIsRing:(NSInteger)isRing{
    if(self.isEdit){
        self.wcEvent.isRing = isRing;
    }else {
        _isRing = isRing;
    }
}
@end


@interface WCCalendarMaker ()
@property (nonatomic,strong) WCCalendar* calendar;
@end


@implementation WCCalendarMaker
- (WCCalendar*)make{
    
    _calendar = [[WCCalendar alloc] init];
    _calendar.kind = ICAL_VCALENDAR_COMPONENT;
    _calendar.method = CALENDAR_Property_Method;
    _calendar.version = CALENDAR_Property_Version;
    _calendar.provide =CALENDAR_Property_Provide;
    return _calendar;
}


- (void)addEventWithBlock:(WCEventMakerBlock)block{

    WCEvent* event = [WCEvent wc_makeEvent:block];
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithArray:self.calendar.subcomponents];
    [tmp addObject:event];
    _calendar.subcomponents = tmp;
}

- (void)addEvent:(WCEvent*)event{
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithArray:self.calendar.subcomponents];
    [tmp addObject:event];
    _calendar.subcomponents = tmp;
}

- (void)update:(WCCalendar*)calendar{
    self.calendar = calendar;
}

- (void)updateEventWithBlock:(NSString*)eventUID block:(WCEventMakerBlock)block{
    
    WCEvent* event = [self.calendar eventWithUID:eventUID];
    [event wc_updateEvent:block];
}


@end