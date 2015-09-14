//
//  NSArray+iCal.m
//  WeCalICS
//
//  Created by nyz_star on 15/8/10.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import "NSArray+iCal.h"
#import "WCRecurrenceDayOfWeek.h"

@implementation NSArray (iCal)

+(id)getArrayWithCShortArray:(const short *)cArray andByType:(WCCalRuleByType)byType{
    NSInteger arrayCount = [self getCShortArrayCountWithByType:byType];
    short maxValue = ICAL_RECURRENCE_ARRAY_MAX;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i= 0; i<arrayCount; i++) {
        short value = cArray[i];
        if (value < maxValue) {
            if(byType == WCCalRuleByDay){
                WCRecurrenceDayOfWeek *day = [WCRecurrenceDayOfWeek dayOfWeekWithFlagValue:value];
                [temp addObject:day];
            } else {
                [temp addObject:[NSNumber numberWithShort:value]];
            }
        } else {
            break;
        }
    }
    NSArray *array = [self arrayWithArray:temp];
    return array;
}

+(id)getArrayWithDataString:(NSString *)dbString andByType:(WCCalRuleByType)byType{
    if (dbString.length <= 0) {
        return [NSArray array];
    }
    NSArray *strArray = [dbString componentsSeparatedByString:@","];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *strValue in strArray) {
        short flagValue = [strValue intValue];
        if (byType == WCCalRuleByDay) {
            WCRecurrenceDayOfWeek *day = [WCRecurrenceDayOfWeek dayOfWeekWithFlagValue:flagValue];
            [tempArray addObject:day];
        } else {
            NSNumber *number = [NSNumber numberWithShort:flagValue];
            [tempArray addObject:number];
        }
    }
    NSArray *array = [self arrayWithArray:tempArray];
    return array;
}

+(id)getFullArrayWithCShoryArray:(const short *)cArray andByType:(WCCalRuleByType)byType{
    NSInteger arrayCount = [self getCShortArrayCountWithByType:byType];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i= 0; i<arrayCount; i++) {
        short value = cArray[i];
        [temp addObject:[NSNumber numberWithShort:value]];
    }
    NSArray *array = [self arrayWithArray:temp];
    return array;
}

+(NSInteger)getCShortArrayCountWithByType:(WCCalRuleByType)byType{
    NSInteger arrayCount = 0;
    switch (byType) {
        case WCCalRuleByDay:
            arrayCount = ICAL_BY_DAY_SIZE;
            break;
        case WCCalRuleByMonthDay:
            arrayCount = ICAL_BY_MONTHDAY_SIZE;
            break;
        case WCCalRuleByYearDay:
            arrayCount = ICAL_BY_YEARDAY_SIZE;
            break;
        case WCCalRuleByMonth:
            arrayCount = ICAL_BY_MONTH_SIZE;
            break;
        case WCCalRuleByWeekNo:
            arrayCount = ICAL_BY_WEEKNO_SIZE;
            break;
        case WCCalRuleByHour:
            arrayCount = ICAL_BY_HOUR_SIZE;
            break;
        case WCCalRuleByMinute:
            arrayCount = ICAL_BY_MINUTE_SIZE;
            break;
        case WCCalRuleBySecond:
            arrayCount = ICAL_BY_SECOND_SIZE;
            break;
        case WCCalRuleByPosition:
            arrayCount = ICAL_BY_SETPOS_SIZE;
            break;
        default:
            break;
    }
    return arrayCount;
}

-(id)getFullArrayWithByType:(WCCalRuleByType)byType{
    NSInteger arrayCount = [[self class] getCShortArrayCountWithByType:byType];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:arrayCount];
    [tempArray addObjectsFromArray:self];
    short maxValue = ICAL_RECURRENCE_ARRAY_MAX;
    if (byType == WCCalRuleByDay) {
        for (int i=0; i<self.count; i++) {
            WCRecurrenceDayOfWeek *weekno = [self objectAtIndex:i];
            NSNumber *numberValue = [NSNumber numberWithInteger:[weekno getFlagValue]];
            [tempArray replaceObjectAtIndex:i withObject:numberValue];
        }
    }
    for (NSInteger i=self.count; i<arrayCount; i++) {
        [tempArray addObject:[NSNumber numberWithShort:maxValue]];
    }
    NSArray *retArray = [NSArray arrayWithArray:tempArray];
    return retArray;
}

-(void)convertIntoCShortArray:(short *)cArray andByType:(WCCalRuleByType)byType{
    NSInteger arrayCount = [[self class] getCShortArrayCountWithByType:byType];
    short maxValue = ICAL_RECURRENCE_ARRAY_MAX;
    for (NSInteger i= 0; i<arrayCount; i++) {
        if (i < self.count) {
            NSNumber *numberValue;
            if (byType == WCCalRuleByDay) {
                WCRecurrenceDayOfWeek *weekno = [self objectAtIndex:i];
                numberValue = [NSNumber numberWithInteger:[weekno getFlagValue]];
            } else {
                numberValue = [self objectAtIndex:i];
            }
            cArray[i] = [numberValue shortValue];
        } else {
            cArray[i] = maxValue;
        }
    }
}

-(NSString *)getDataBaseSaveString{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id number in self) {
        NSString *itemStr = @"";
        if ([number isKindOfClass:[WCRecurrenceDayOfWeek class]]) {
            itemStr = [NSString stringWithFormat:@"%zd",[(WCRecurrenceDayOfWeek *)number getFlagValue]];
        } else {
            itemStr = [NSString stringWithFormat:@"%@",number];
        }
        [tempArray addObject:itemStr];
    }
    if (tempArray.count > 0) {
        NSString *retString = [tempArray componentsJoinedByString:@","];
        return retString;
    } else {
        return @"";
    }
}

@end
