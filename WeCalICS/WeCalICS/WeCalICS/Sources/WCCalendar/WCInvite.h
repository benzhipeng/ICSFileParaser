//
//  WCInvite.h
//  WCCal
//
//  Created by Andrew Halls on 8/5/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import "ical.h"
#import "WCCalendar.h"

typedef NS_ENUM(NSInteger, WCInviteResponse) {
    WCInviteResponseUnknown = -1,
    WCInviteResponseAccept,
    WCInviteResponseDecline,
    WCInviteResponseTenative
};

@interface WCInvite : NSObject

+(WCCalendar *) inviteResponseFromCalendar: (WCCalendar *) calendar
                                    fromEmail: (NSString *) email
                                     response:(WCInviteResponse) response;

+(WCInviteResponse) responseForCalendar:(WCCalendar *) calendar
                                 forEmail:(NSString *) email;

@end
