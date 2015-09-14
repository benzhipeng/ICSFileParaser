//
//  NSDate+iCal.m
//  WeCalICS
//
//  Created by nyz_star on 15/8/11.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import "NSDate+iCal.h"

@implementation NSDate (iCal)

+(NSDate *)dateWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day{
    NSDate *retDate = [self dateWithYear:year andMonth:month andDay:day andHour:0 andMinute:0 andSecond:0];
    return retDate;
}

+(NSDate *)dateWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day andHour:(NSInteger)hour andMinute:(NSInteger)minute andSecond:(NSInteger)second{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.year = year;
    comp.month = month;
    comp.day = day;
    comp.hour = hour;
    comp.minute = minute;
    comp.second = second;
    NSDate *retDate = [calendar dateFromComponents:comp];
    return retDate;
}


@end


@implementation NSDate (TimeStamp)
- (long long)timeStamp{

    return (long long)(floor([self timeIntervalSince1970] * 1000)); //当前时区的时间戳
}


@end