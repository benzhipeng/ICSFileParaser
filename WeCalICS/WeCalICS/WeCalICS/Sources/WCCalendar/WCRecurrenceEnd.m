//
//  WCRecurrenceEnd.m
//  iCalDemo
//
//  Created by nyz_star on 15/8/6.
//  Copyright (c) 2015年 nyz_star. All rights reserved.
//

#import "WCRecurrenceEnd.h"

@implementation WCRecurrenceEnd

-(id)initWithEndDate:(NSDate *)endDate{
    self = [super init];
    if (self) {
        _endType = WCRecurrenceEndTypeDate;
        _endDate = endDate;
    }
    return self;
}

-(id)initWithEndCount:(NSInteger)endCount{
    self = [super init];
    if (self) {
        _endType = WCRecurrenceEndTypeCount;
        _endCount = endCount;
    }
    return self;
}

-(id)initWithNoneEndType{
    self = [super init];
    if (self) {
        _endType = WCRecurrenceEndTypeNone;
    }
    return self;
}

+(id)recurrenceEndWithEndDate:(NSDate *)endDate{
    WCRecurrenceEnd *end = [[self alloc] initWithEndDate:endDate];
    return end;
}

+(id)recurrenceEndWithEndCount:(NSUInteger)endCount{
    WCRecurrenceEnd *end = [[self alloc] initWithEndCount:endCount];
    return end;
}

+(id)noneRecurrenceEnd{
    WCRecurrenceEnd *end = [[self alloc] initWithNoneEndType];
    return end;
}

@end
