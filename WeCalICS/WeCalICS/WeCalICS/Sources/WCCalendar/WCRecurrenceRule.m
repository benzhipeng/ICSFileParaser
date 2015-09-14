//
//  WCRecurrenceRule.m
//  WCIcs
//
//  Created by nyz_star on 15/8/10.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import "WCRecurrenceRule.h"

@implementation WCRecurrenceRule

-(id)init{
    self = [super init];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}

-(id)initWithRecurrenceRuleString:(NSString *)rrule{
    self = [super init];
    if (self) {
        [self setDefaultValue];
        if(rrule == nil){
            rrule = @"";
        }
        self.rrule = rrule;
        if (rrule.length <= 0) {
            
        } else {
            struct icalrecurrencetype rruleStruct = icalrecurrencetype_from_string([rrule cStringUsingEncoding:NSUTF8StringEncoding]);
            [self convertiCalRecurrenceToSelf:rruleStruct];
        }
    }
    return self;
}

-(id)initRecurrenceWithFrequency:(WCRecurrenceFrequency)type interval:(NSInteger)interval byDay:(NSArray *)days byMonthDay:(NSArray *)monthDays byYearMonth:(NSArray *)months byWeekno:(NSArray *)weeksOfTheYear byYearDay:(NSArray *)daysOfTheYear end:(WCRecurrenceEnd *)end rule:(NSString *)rule{
    self = [super init];
    if (self) {
        [self setDefaultValue];
        self.rrule = rule;
        self.frequency = type;
        self.interval = interval;
        self.byDay = days==nil?[NSArray array]:days;
        self.byMonthDay = monthDays==nil?[NSArray array]:monthDays;
        self.byYearDay = daysOfTheYear==nil?[NSArray array]:daysOfTheYear;
        self.byMonth = months==nil?[NSArray array]:months;
        self.byWeekNo = weeksOfTheYear==nil?[NSArray array]:weeksOfTheYear;
        self.end = end;
    }
    return self;
}

-(id)initRecurrenceWithFrequency:(WCRecurrenceFrequency)type interval:(NSInteger)interval end:(WCRecurrenceEnd *)end rule:(NSString *)rule{
    self = [super init];
    if (self) {
        [self setDefaultValue];
        self.rrule = rule;
        self.frequency = type;
        self.interval = interval;
        self.end = end;
    }
    return self;
}

-(void)setDefaultValue{
    // set default value
    self.weekStart = ICAL_SUNDAY_WEEKDAY;
    self.rrule = @"";
    self.frequency = WCRecurrenceFrequencyNone;
    self.end = [WCRecurrenceEnd noneRecurrenceEnd];
    self.byDay = [NSArray array];
    self.byMonthDay = [NSArray array];
    self.byYearDay = [NSArray array];
    self.byMonth = [NSArray array];
    self.byWeekNo = [NSArray array];
}
//+(WCRecurrenceFrequency)getWCRecurrenceFrequencyFromStruct:(struct icalrecurrencetype)rruleStruct{
//    WCRecurrenceFrequency fre = WCRecurrenceFrequencyNone;
//    switch (rruleStruct.freq) {
//        case ICAL_DAILY_RECURRENCE:
//            fre = WCRecurrenceFrequencyDaily;
//            break;
//        case ICAL_WEEKLY_RECURRENCE:
//            fre = WCRecurrenceFrequencyWeekly;
//            break;
//        case ICAL_MONTHLY_RECURRENCE:
//            fre = WCRecurrenceFrequencyMonthly;
//            break;
//        case ICAL_YEARLY_RECURRENCE:
//            fre = WCRecurrenceFrequencyYearly;
//            break;
//        default:
//            //不支持的暂时都默认不重复
//            fre = WCRecurrenceFrequencyNone;
//            break;
//    }
//    return fre;
//}

//+(icalrecurrencetype_frequency )getStructFrequencyTypeFromWCRF:(WCRecurrenceFrequency )fre{
//    icalrecurrencetype_frequency structFre = ICAL_NO_RECURRENCE;
//    switch (fre) {
//        case WCRecurrenceFrequencyDaily:
//            structFre = ICAL_DAILY_RECURRENCE;
//            break;
//        case WCRecurrenceFrequencyMonthly:
//            structFre = ICAL_MONTHLY_RECURRENCE;
//            break;
//        case WCRecurrenceFrequencyWeekly:
//            structFre = ICAL_WEEKLY_RECURRENCE;
//            break;
//        case WCRecurrenceFrequencyYearly:
//            structFre = ICAL_YEARLY_RECURRENCE;
//        default:
//            structFre = ICAL_NO_RECURRENCE;                     //不重复
//            break;
//    }
//    return structFre;
//}


-(void)convertiCalRecurrenceToSelf:(struct icalrecurrencetype)rruleStruct{
    //fre
    self.frequency = (NSInteger)rruleStruct.freq;
    //interval
    self.interval = rruleStruct.interval;
    //by s
    self.byDay = [NSArray getArrayWithCShortArray:rruleStruct.by_day andByType:WCCalRuleByDay];
    self.byMonthDay = [NSArray getArrayWithCShortArray:rruleStruct.by_month_day andByType:WCCalRuleByMonthDay];
    self.byYearDay = [NSArray getArrayWithCShortArray:rruleStruct.by_year_day andByType:WCCalRuleByYearDay];
    self.byMonth = [NSArray getArrayWithCShortArray:rruleStruct.by_month andByType:WCCalRuleByMonth];
    self.byWeekNo = [NSArray getArrayWithCShortArray:rruleStruct.by_week_no andByType:WCCalRuleByWeekNo];
    
    //weekstart
    self.weekStart = rruleStruct.week_start;
    //end
    if (rruleStruct.count > 0) {
        self.end = [WCRecurrenceEnd recurrenceEndWithEndCount:rruleStruct.count];
    } else {
        if (rruleStruct.until.year == 0) {
            self.end = [WCRecurrenceEnd noneRecurrenceEnd];
        } else {
            time_t seconds = icaltime_as_timet(rruleStruct.until);
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:seconds];
            self.end = [WCRecurrenceEnd recurrenceEndWithEndDate:endDate];
        }
    }

}

-(struct icalrecurrencetype)getEqualRecurrenceRuleStructFromSelf{
    struct icalrecurrencetype rruleStruct = icalrecurrencetype_from_string([_rrule cStringUsingEncoding:NSUTF8StringEncoding]);
    //fre
    rruleStruct.freq = (int)self.frequency;
    //interval
    rruleStruct.interval = self.interval;
    //by s
    [self.byDay convertIntoCShortArray:rruleStruct.by_day andByType:WCCalRuleByDay];
    [self.byMonthDay convertIntoCShortArray:rruleStruct.by_month_day andByType:WCCalRuleByMonthDay];
    [self.byYearDay convertIntoCShortArray:rruleStruct.by_year_day andByType:WCCalRuleByYearDay];
    [self.byMonth convertIntoCShortArray:rruleStruct.by_month andByType:WCCalRuleByMonth];
    [self.byWeekNo convertIntoCShortArray:rruleStruct.by_week_no andByType:WCCalRuleByWeekNo];
    
    //weekstart
    rruleStruct.week_start = (int)self.weekStart;
    //end
    if (self.end.endType == WCRecurrenceEndTypeCount) {
        rruleStruct.count = (int)self.end.endCount;
    } else if(self.end.endType == WCRecurrenceEndTypeDate) {
        time_t seconds = [self.end.endDate timeIntervalSince1970];
        struct icaltimetype until = icaltime_from_timet(seconds,self.isAllDay);
        rruleStruct.until = until;
    }
    
    return rruleStruct;
}

-(NSString *)getConvertRecurrenceRuleString{
    struct icalrecurrencetype rrule = [self getEqualRecurrenceRuleStructFromSelf];
    char *cString = icalrecurrencetype_as_string(&rrule);
    
    NSString *iCalRRuleStr = @"";
    if (cString != NULL) {
        iCalRRuleStr = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    }
    return iCalRRuleStr;
}

-(NSDictionary *)getConvertRecurrenceRuleDicValue{
    NSMutableDictionary *dicValue = [NSMutableDictionary dictionary];
    struct icalrecurrencetype rrule = [self getEqualRecurrenceRuleStructFromSelf];
    icalrecurrencetype_frequency fre = (int)self.frequency;
    //fre
    [dicValue setObject:[NSNumber numberWithInt:fre] forKey:@"freq"];
    //interval
    [dicValue setObject:[NSNumber numberWithInteger:self.interval] forKey:@"interval"];
    
    //by s
    NSArray *array1 = [self.byDay getFullArrayWithByType:WCCalRuleByDay];
    [dicValue setObject:array1 forKey:@"by_day"];
    [dicValue setObject:[self.byMonthDay getFullArrayWithByType:WCCalRuleByMonthDay] forKey:@"by_month_day"];
    [dicValue setObject:[self.byYearDay getFullArrayWithByType:WCCalRuleByYearDay] forKey:@"by_year_day"];
    [dicValue setObject:[self.byMonth getFullArrayWithByType:WCCalRuleByMonth] forKey:@"by_month"];
    [dicValue setObject:[self.byWeekNo getFullArrayWithByType:WCCalRuleByWeekNo] forKey:@"by_week_no"];
    
    //by not use
    [dicValue setObject:[NSArray getFullArrayWithCShoryArray:rrule.by_hour andByType:WCCalRuleByHour] forKey:@"by_hour"];
    [dicValue setObject:[NSArray getFullArrayWithCShoryArray:rrule.by_minute andByType:WCCalRuleByMinute] forKey:@"by_minute"];
    [dicValue setObject:[NSArray getFullArrayWithCShoryArray:rrule.by_second andByType:WCCalRuleBySecond] forKey:@"by_second"];
    [dicValue setObject:[NSArray getFullArrayWithCShoryArray:rrule.by_set_pos andByType:WCCalRuleByPosition] forKey:@"by_set_pos"];
    
    //week start
    [dicValue setObject:[NSNumber numberWithInteger:self.weekStart] forKey:@"week_start"];
    //end
    NSInteger count;
    id until;
    if (self.end.endType == WCRecurrenceEndTypeNone) {
        until = [NSNull null];
        count = 0;
    } else if (self.end.endType == WCRecurrenceEndTypeCount){
        until = [NSNull null];
        count = self.end.endCount;
    } else {
        until = self.end.endDate;
        count = 0;
    }
    [dicValue setObject:until forKey:@"until"];
    [dicValue setObject:[NSNumber numberWithInteger:count] forKey:@"count"];
    
    //other
    if (rrule.rscale != NULL) {
        [dicValue setObject:[NSString stringWithCString:rrule.rscale encoding:NSUTF8StringEncoding] forKey:@"rscale"];
    }
    [dicValue setObject:[NSNumber numberWithInt:rrule.skip] forKey:@"skip"];
    
    return dicValue;
}


-(BOOL)isEqualToRule:(WCRecurrenceRule *)rule{
    BOOL flag = YES;
    if (self != rule) {
        NSString *str1 = [self getConvertRecurrenceRuleString];
        NSString *str2 = [rule getConvertRecurrenceRuleString];
        flag = [str1 isEqualToString:str2];
    }
    return flag;
}

-(BOOL)hasChange{
    WCRecurrenceRule *oriRule = [[WCRecurrenceRule alloc] initWithRecurrenceRuleString:_rrule];
    BOOL flag = [self isEqualToRule:oriRule];
    return !flag;
}

@end
