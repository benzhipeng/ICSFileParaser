//
//  WCRecurrenceDayOfWeek.h
//  WCIcs
//
//  Created by nyz_star on 15/8/10.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  在第几周的第几天 封装的对象 已经重写isEqual 可以直接比较 hash 方法也已经重写了，array 和 dic 可以直接获取 indexOfObject
 */

@interface WCRecurrenceDayOfWeek : NSObject

/**
 *  根据解析库解析的flag value 解析到属性里面
 *
 *  @param flagValue value=(k)*((n*8)+d) k:+-1 n:weekNumber d:dayOfTheWeek
 *
 *  @return WCRecurrenceDayOfWeek 实例
 */

+(id)dayOfWeekWithFlagValue:(NSInteger)flagValue;


//表示周几 SU＝1 MO＝2 ... ST=7
@property(nonatomic,readonly) NSInteger dayOfTheWeek;

//表示第几周 0表示every week 正值表示第几周 负值表示倒数第几周
@property(nonatomic,readonly) NSInteger weekNumber;

-(NSInteger)getFlagValue;

@end
