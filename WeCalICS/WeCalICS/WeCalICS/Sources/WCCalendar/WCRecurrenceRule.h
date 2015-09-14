//
//  WCRecurrenceRule.h
//  WCIcs
//
//  Created by nyz_star on 15/8/10.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCRecurrenceEnd.h"
#import "NSArray+iCal.h"
#import "ical.h"
//重复类型

typedef enum : NSUInteger {
    WCRecurrenceFrequencyNone    = ICAL_NO_RECURRENCE,
    WCRecurrenceFrequencyDaily   = ICAL_DAILY_RECURRENCE,
    WCRecurrenceFrequencyWeekly  = ICAL_WEEKLY_RECURRENCE,
    WCRecurrenceFrequencyMonthly = ICAL_MONTHLY_RECURRENCE,
    WCRecurrenceFrequencyYearly  = ICAL_YEARLY_RECURRENCE
} WCRecurrenceFrequency;

@interface WCRecurrenceRule : NSObject

@property(nonatomic) NSInteger ruleId;

/*============ event cache begin ======*/

@property(nonatomic) NSInteger eventId;

//活动开始日期的拆解的年月日
@property(nonatomic) NSInteger eventSyear;

@property(nonatomic) NSInteger eventSmonth;

@property(nonatomic) NSInteger eventSday;

@property(nonatomic) BOOL isAllDay;

/*============ event cache end ========*/

/*============ WCRecurrenceRule =======*/

@property(nonatomic,strong,getter=getConvertRecurrenceRuleString) NSString *rrule;

//重复类型
@property(nonatomic) WCRecurrenceFrequency frequency;
//重复终止 参考WCRecurrenceEnd class
@property(nonatomic,strong) WCRecurrenceEnd *end;
//重复间隔
@property(nonatomic,assign) NSInteger interval;
//某个月中哪几天重复 元素取值范围 [1 ~ 31] 和 [-31 ~ -1]  负数表示倒数
@property(nonatomic,strong) NSArray *byMonthDay;
//一年中的哪几个月重复 元素取值范围 [1 ~ 12]
@property(nonatomic,strong) NSArray *byMonth;
//一年或者一个月中哪几周重复 元素取值范围 [1 ~ 53] 和 [-53 ~ -1] 负数表示倒数
@property(nonatomic,strong) NSArray *byWeekNo;
//一年中哪几天重复 元素取值范围 [1 ~ 366] 和 [-366 ~ -1] 负数表示倒数
@property(nonatomic,strong) NSArray *byYearDay;
//一年或者一个月中的哪几天重复 元素 参考 WCRecurrenceDayOfWeek class
@property(nonatomic,strong) NSArray *byDay;
//周首日 取值范围0和[1,7]=[SUN,MON…,STA] 0表示没设置。按周重复并且recurrence_interval 大于1 才会产生影响，其他情况该值忽略
@property(nonatomic,assign) NSInteger weekStart;


// not use
////一天中哪几个小时重复 元素取值范围[0 ~ 23]
//@property(nonatomic,strong) NSArray *byHour;
////一小时中哪几个分钟重复 元素取值范围[0 ~ 59]
//@property(nonatomic,strong) NSArray *byMinute;
////一分钟中哪几个秒重复 元素取值范围[0 ~ 59]
//@property(nonatomic,strong) NSArray *bySeconds;




/*============ WCRecurrenceRule =======*/

// read and write with iCal string
-(id)initWithRecurrenceRuleString:(NSString *)rrule;

-(NSString *)getConvertRecurrenceRuleString;

-(NSDictionary *)getConvertRecurrenceRuleDicValue;

//with database
- (id)initRecurrenceWithFrequency:(WCRecurrenceFrequency)type
                         interval:(NSInteger)interval
                            byDay:(NSArray *)days
                       byMonthDay:(NSArray *)monthDays
                      byYearMonth:(NSArray *)months
                         byWeekno:(NSArray *)weeksOfTheYear
                        byYearDay:(NSArray *)daysOfTheYear
                              end:(WCRecurrenceEnd *)end
                             rule:(NSString *)rule;

- (id)initRecurrenceWithFrequency:(WCRecurrenceFrequency)type interval:(NSInteger)interval end:(WCRecurrenceEnd *)end rule:(NSString *)rule;

//other methods
-(BOOL)isEqualToRule:(WCRecurrenceRule *)rule;

//是否发生改变
-(BOOL)hasChange;

@end
