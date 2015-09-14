//
//  NSArray+iCal.h
//  WeCalICS
//
//  Created by nyz_star on 15/8/10.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDefine.h"
#import "ical.h"



@interface NSArray (iCal)

+(id)getArrayWithCShortArray:(const short *)cArray andByType:(WCCalRuleByType)byType;

+(id)getArrayWithDataString:(NSString *)dbString andByType:(WCCalRuleByType)byType;

+(id)getFullArrayWithCShoryArray:(const short *)cArray andByType:(WCCalRuleByType)byType;

+(NSInteger)getCShortArrayCountWithByType:(WCCalRuleByType)byType;

-(id)getFullArrayWithByType:(WCCalRuleByType)byType;

-(void)convertIntoCShortArray:(short *)cArray andByType:(WCCalRuleByType)byType;

-(NSString *)getDataBaseSaveString;

@end
