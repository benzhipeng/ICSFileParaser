//
//  WCCalMaker.h
//  WCIcs
//
//  Created by zhipeng ben on 10/8/2015.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WCEvent;
@class WCCalendar;
@class WCCalendarMaker;
@class WCEventMaker;
@class WCRecurrenceRule;
@class WCLocation;
typedef void(^WCEventMakerBlock)(WCEventMaker* maker);
typedef void(^WCCalendarMakerBlock)(WCCalendarMaker* maker);



@interface WCEventMaker : NSObject
@property (nonatomic,strong) NSDate*  dateStart;/**< 开始时间*/
@property (nonatomic,strong) NSDate*  dateEnd;/**< 结束时间*/
@property (nonatomic,strong) NSDate*  dateCreated; /**< 活动创建时间*/
@property (nonatomic,strong) NSDate*  dateLastModified; /**< 修改时间*/
@property (nonatomic,strong) NSString* desc; /**< 备注*/
@property (nonatomic,strong) NSString* status; /**< 状态*/
@property (nonatomic,strong) NSString* summary; /**< 活动的主题*/
@property (nonatomic,strong) WCRecurrenceRule *rrule; /**< 重复规则*/
@property (nonatomic,strong) NSString* url; /**< This property defines a Uniform Resource Locator (URL) associated with the iCalendar object*/
@property (nonatomic,strong) NSArray* attendees; /**< 参加活动的人*/
@property (nonatomic,assign) BOOL     isAllDay; /**< 是否是全天*/
@property (nonatomic,strong) WCLocation* locationExt; /**< 位置*/
@property (nonatomic,strong) NSString* advance; /**< 提醒时间 eg. "5,10,15" ps.单位(分钟)*/
@property (nonatomic,assign) NSInteger  isRing; /**< 是否提醒*/

- (WCEvent*)make;

- (void)update:(WCEvent*)event;
@end


@interface WCCalendarMaker : NSObject

/**
 *  @brief  向calendar中添加event
 *
 *  @param block 组装event的block
 */
- (void)addEventWithBlock:(WCEventMakerBlock)block;


- (void)addEvent:(WCEvent*)event;

- (WCCalendar*)make;

/**
 *  @brief  修改calendar中的某一个event
 *
 *  @param eventUID event的uid
 *  @param block    修改event的block
 */
- (void)updateEventWithBlock:(NSString*)eventUID block:(WCEventMakerBlock)block;
- (void)update:(WCCalendar*)calendar;

@end

