//
//  WCCalendar.h
//
#import "ical.h"
#import "WCComponent.h"

#import "WCCalMaker.h"

@interface WCCalendar : WCComponent

@property (nonatomic,copy) NSString* version;
@property (nonatomic,copy) NSString* method;
@property (nonatomic,copy) NSString* provide;

//初始化方法
/**
 *  @brief  根据ics内容创建
 *
 *  @param content ics字符串
 *
 *  @return WCCalendar对象
 */
+ (WCCalendar*)calendarWithString:(NSString*)content;

/**
 *  @brief  根据maker创建
 *
 *  @param block 该block可以给calendar赋值
 *
 *  @return WCCalendar对象
 */
+ (WCCalendar*)wc_makeCalendar:(WCCalendarMakerBlock)block;



- (void)wc_updateCalendar:(WCCalendarMakerBlock)block;


/**
 *  @brief  解析calendar
 *
 *  @param content ics内容
 *  @param events  解析出来的event对象
 */
+ (void)calendarParaser:(NSString*)content events:(void(^)(NSArray* events))events;


/**
 *  @brief  根据uid查询event
 *
 *  @param uid event的唯一标识
 *
 *  @return event对象
 */
- (WCEvent*)eventWithUID:(NSString*)uid;


@end

