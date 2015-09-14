//
//  WCCalHelper.h
//  WCIcs
//
//  Created by zhipeng ben on 7/8/2015.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCCal.h"


typedef void(^ICALParaserFinishedBlock)(NSArray* events);
@interface WCCalHelper : NSObject
+ (instancetype)shareICALHelper;

/**
 *  @brief  解析ics
 *
 *  @param icsString       ics的内容
 *  @param paraserFinished 解析结束的回调
 */
- (void)paraserICALWithString:(NSString*)ics paraserFinished:(ICALParaserFinishedBlock)paraserFinished;


/**
 *  @brief  批量解析ics
 *
 *  @param icses              ics数组
 *  @param paraserFinished    一个ics解析结束之后的回调
 *  @param paraserAllFinished 所有的ics解析结束之后的回调
 */
- (void)batchParaserICALContent:(NSArray*)icses paraserFinished:(ICALParaserFinishedBlock)paraserFinished paraserAllFinished:(void(^)(BOOL sucess))paraserAllFinished;
@end
