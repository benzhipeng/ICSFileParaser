//
//  WCRecurrenceEnd.h
//  iCalDemo
//
//  Created by nyz_star on 15/8/6.
//  Copyright (c) 2015年 nyz_star. All rights reserved.
//

#import <Foundation/Foundation.h>


//重复终止类型
typedef enum : NSUInteger {
    WCRecurrenceEndTypeNone      = -1,
    WCRecurrenceEndTypeCount     = 0,
    WCRecurrenceEndTypeDate      = 1
} WCRecurrenceEndType;

@interface WCRecurrenceEnd : NSObject

/*!
 @method     recurrenceEndWithEndDate:
 @abstract   Creates an autoreleased recurrence end with a specific end date.
 */
+ (id)recurrenceEndWithEndDate:(NSDate *)endDate;

/*!
 @method     recurrenceEndWithEndCount:
 @abstract   Creates an autoreleased recurrence end with a maximum occurrence count.
 */
+ (id)recurrenceEndWithEndCount:(NSUInteger)occurrenceCount;

/*!
 @method     recurrenceEndWithEndCount:
 @abstract   Creates an autoreleased recurrence end with WCRecurrenceEndTypeNone
 */
+ (id)noneRecurrenceEnd;

/**
 *  重复终止类型
 */
@property(nonatomic,readonly) WCRecurrenceEndType endType;

/**
 *  重复截止日期
 */
@property(nonatomic,readonly,copy) NSDate *endDate;
/**
 *  重复截止次数
 */
@property(nonatomic,readonly) NSInteger endCount;

@end
