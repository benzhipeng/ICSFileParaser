//
//  WCInvite.m
//  WCCal
//
//  Created by Andrew Halls on 8/5/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import "WCInvite.h"
#import "WCEvent.h"

@implementation WCInvite

+(WCCalendar *) inviteResponseFromCalendar: (WCCalendar *) calendar
                                    fromEmail: (NSString *) email
                                     response: (WCInviteResponse) response {
    
    WCCalendar * newCalendar = [calendar copy];
    [newCalendar setMethod:@"REPLY"];
    
    WCEvent * event = (WCEvent *) [newCalendar firstComponentOfKind:ICAL_VEVENT_COMPONENT];
    if (event) {
        [event updateAttendeeWithEmail:email withResponse:response];
    }
    
    return newCalendar;
}

+(WCInviteResponse) responseForCalendar:(WCCalendar *) calendar
                                 forEmail:(NSString *) email {

  WCInviteResponse result = WCInviteResponseUnknown;
  

  WCEvent * event = (WCEvent *) [calendar firstComponentOfKind:ICAL_VEVENT_COMPONENT];
  if (event) {
    result = [event lookupAttendeeStatusForEmail: email];
  }


  return result;

}



@end
