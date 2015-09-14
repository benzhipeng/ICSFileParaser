//
//  WCRecurrenceDayOfWeek.m
//  WCIcs
//
//  Created by nyz_star on 15/8/10.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import "WCRecurrenceDayOfWeek.h"

@implementation WCRecurrenceDayOfWeek

-(id)initWithFlagValue:(NSInteger)flagValue{
    self = [super init];
    if (self) {
        NSInteger k,n,d;
        //  notice      flagValue =(k)*((n*8)+d) k:+-1 n:weekNumber d:dayOfTheWeek
        if (flagValue < 0) {
            k = -1;
            flagValue = -flagValue;
        } else {
            k = 1;
        }
        n = flagValue/8;
        d = flagValue%8;
        _dayOfTheWeek = d;
        _weekNumber = n*k;
    }
    return self;
}

+(id)dayOfWeekWithFlagValue:(NSInteger)flagValue{
    WCRecurrenceDayOfWeek *dayOfWeek = [[self alloc] initWithFlagValue:flagValue];
    return dayOfWeek;
}

-(NSInteger)getFlagValue{
    NSInteger value ,k;
    if (_weekNumber < 0) {
        k = -1;
    }else {
        k = 1;
    }
    value = _weekNumber*8+k*_dayOfTheWeek;
    return value;
}

-(BOOL)isEqual:(id)object{
    BOOL flag = [super isEqual:object];
    if (flag) {
        flag = ([self getFlagValue] == [object getFlagValue]);
    }
    return flag;
}

-(NSUInteger)hash{
    NSNumber *flagValue = [NSNumber numberWithInteger:[self getFlagValue]];
    return [flagValue hash];
}

@end
