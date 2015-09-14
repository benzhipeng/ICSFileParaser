//
//  WCVEvent.h
//

#import "ical.h"
#import "WCComponent.h"
#import "WCPerson.h"
#import "WCInvite.h"
#import "WCRecurrenceRule.h"
#import "WCLocation.h"

@class WCEventMaker;

@interface WCEvent : WCComponent

@property (nonatomic,strong) NSDate*  dateStart; /**< 开始时间*/
@property (nonatomic,strong) NSDate*  dateEnd; /**< 结束时间*/
@property (nonatomic,assign) NSInteger isAllDay; /**< 是否是全天*/
@property (nonatomic,strong) NSDate*  dateStamp;
@property (nonatomic,strong) NSDate*  dateCreated; /**< 活动创建时间*/
@property (nonatomic,strong) NSDate*  dateLastModified; /**< 修改时间*/
@property (nonatomic,strong) WCPerson* organizer;
@property (nonatomic,strong) NSString* UID; /**< 活动的唯一标识*/
@property (nonatomic,strong) NSArray* attendees; /**< 参加活动的人*/
@property (nonatomic,strong) NSString* url; /**< This property defines a Uniform Resource Locator (URL) associated with the iCalendar object*/
@property (nonatomic,strong) NSString* desc; /**< 备注*/
@property (nonatomic,strong) NSString* status; /**< 状态*/
@property (nonatomic,strong) NSString* summary; /**< 活动的主题*/
@property (nonatomic,strong) NSArray* sequences;
@property (nonatomic,strong) WCRecurrenceRule *rrule; /**< 重复规则*/
@property (nonatomic,strong) WCLocation*    locationExt;/**< 位置*/
@property (nonatomic,strong) NSString* advance; /**< 提醒时间 eg. "5,10,15" ps.单位(分钟)*/
@property (nonatomic,assign) NSInteger  isRing; /**< 是否提醒*/


- (void) updateAttendeeWithEmail: (NSString *) email withResponse: (WCInviteResponse) response;

- (WCInviteResponse) lookupAttendeeStatusForEmail: (NSString *) email;

- (BOOL)locationIsURLValueKind;

/**
 *  @brief  由WCComponent中的属性给event的字段赋值
 */
- (void)read;

/**
 *  @brief  创建event
 *
 *  @param block 该block可以给block赋值
 *
 *  @return event对象
 */
+ (WCEvent*)wc_makeEvent:(WCEventMakerBlock)block;


- (void)wc_updateEvent:(WCEventMakerBlock)block;
@end


