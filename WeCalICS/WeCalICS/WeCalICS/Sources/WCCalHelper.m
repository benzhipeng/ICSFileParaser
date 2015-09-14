//
//  WCCalHelper.m
//  WCIcs
//
//  Created by zhipeng ben on 7/8/2015.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import "WCCalHelper.h"

@interface WCCalHelper ()
@property (nonatomic,strong) dispatch_queue_t paraserQueue; /**<数据解析的并行队列 */
@end

@implementation WCCalHelper

+ (instancetype)shareICALHelper{
    
    static WCCalHelper * icalHelper = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        icalHelper = [[WCCalHelper alloc] init];
    });
    return icalHelper;
}

- (id)init{
    if(self = [super init]){
        
        self.paraserQueue = dispatch_queue_create("com.WCICALHelper.paraser.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)paraserICALWithString:(NSString*)ics paraserFinished:(ICALParaserFinishedBlock)paraserFinished{

    dispatch_async(self.paraserQueue, ^{
        [WCCalendar calendarParaser:ics events:^(NSArray *events) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(paraserFinished){
                    paraserFinished(events);
                }
            });
        }];
    });
}

- (void)batchParaserICALContent:(NSArray*)icses paraserFinished:(ICALParaserFinishedBlock)paraserFinished paraserAllFinished:(void(^)(BOOL sucess))paraserAllFinished{
    
    dispatch_group_t group = dispatch_group_create();
    __block BOOL sucess = YES;
    for(NSString*  icsContent in icses){
        dispatch_group_async(group, self.paraserQueue, ^{
            [WCCalendar calendarParaser:icsContent events:^(NSArray *events) {
                if(!events){
                    sucess = NO;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(paraserFinished){
                        paraserFinished(events);
                    }
                });
            }];
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if(paraserAllFinished){
            paraserAllFinished(sucess);
        }
    });
}
@end
