//
//  NSDate+iCal.h
//  WeCalICS
//
//  Created by nyz_star on 15/8/11.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (iCal)

+(NSDate *)dateWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;

+(NSDate *)dateWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day andHour:(NSInteger)hour andMinute:(NSInteger)minute andSecond:(NSInteger)second;

@end

@interface NSDate (TimeStamp)
- (long long)timeStamp;
@end