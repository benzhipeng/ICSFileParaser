//
//  WCEvent.m
//

#import "WCEvent.h"
#import "WCInvite.h"
#import <vis.h>

NSString* X_WC_LOCATION = @"X-WC-LOCATION";
NSString* X_WC_PERSON = @"X-WC-PERSON";
NSString* X_WC_ADVANCE = @"X-WC-ADVANCE";
NSString* X_WC_ISRING = @"X-WC-ISRING";

@interface NSString (Escaping)

+ (NSString *)stringByEscapingMetacharacters:(NSString*)str;

@end

@implementation NSString (Escaping)

+ (NSString *)stringByEscapingMetacharacters:(NSString*)str
{
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return str;
}

@end
@implementation WCEvent

#pragma mark setter
- (void)setDesc:(NSString *)desc{
    
    if(!desc || (desc && desc.length <= 0)){
        [self removePropertyOfKind:ICAL_DESCRIPTION_PROPERTY];
        return;
    }
    if([self.desc isEqualToString:desc]){
        return;
    }
    [self removePropertyOfKind:ICAL_DESCRIPTION_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_DESCRIPTION_PROPERTY;
    pro.valueKind = ICAL_TEXT_VALUE;
    pro.value = desc;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    _desc = (NSString *)[[self firstPropertyOfKind:ICAL_DESCRIPTION_PROPERTY] value];
}

- (void)setSummary:(NSString *)summary{

    if(!summary || (summary && summary.length <= 0)){
        [self removePropertyOfKind:ICAL_SUMMARY_PROPERTY];
        return;
    }
    if([self.summary isEqualToString:summary]){
        return;
    }
    
    [self removePropertyOfKind:ICAL_SUMMARY_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_SUMMARY_PROPERTY;
    pro.valueKind = ICAL_TEXT_VALUE;
    pro.value = summary;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    _summary = (NSString *)[[self firstPropertyOfKind:ICAL_SUMMARY_PROPERTY] value];
}

- (void)setDateStart:(NSDate *)dateStart{
    
    if(!dateStart){
        return;
    }
    if([self.dateStart isEqualToDate:dateStart]){
        return;
    }
    [self removePropertyOfKind:ICAL_DTSTART_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_DTSTART_PROPERTY;
    if(!self.isAllDay){
        pro.valueKind = ICAL_DATETIME_VALUE;
    }else {
        pro.valueKind = ICAL_DATE_VALUE;
    }
    
    pro.value = dateStart;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    _dateStart = (NSDate *)[[self firstPropertyOfKind:ICAL_DTSTART_PROPERTY] value];
    [self configIsAllDay];
}

- (void)setDateEnd:(NSDate *)dateEnd{
    if(!dateEnd){
        return;
    }
    if([self.dateEnd isEqualToDate:dateEnd]){
        return;
    }
    [self removePropertyOfKind:ICAL_DTEND_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_DTEND_PROPERTY;
    if(!self.isAllDay){
        pro.valueKind = ICAL_DATETIME_VALUE;
    }else {
        pro.valueKind = ICAL_DATE_VALUE;
    }
    pro.value = dateEnd;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    _dateEnd = (NSDate *)[[self firstPropertyOfKind:ICAL_DTEND_PROPERTY] value];
}

- (void)setUID:(NSString *)UID{

    if(!UID){
        return;
    }
    if([self.UID isEqualToString:UID]){
        return;
    }
    [self removePropertyOfKind:ICAL_UID_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_UID_PROPERTY;
    pro.valueKind = ICAL_TEXT_VALUE;
    pro.value = UID;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    _UID = (NSString *)[[self firstPropertyOfKind:ICAL_UID_PROPERTY] value];
}


- (void)setRrule:(WCRecurrenceRule *)rrule{
    
    if(!rrule){
        [self removePropertyOfKind:ICAL_RRULE_PROPERTY];
        return;
    }
    if(self.rrule && [self.rrule isEqualToRule:rrule]){
        return;
    }
    [self removePropertyOfKind:ICAL_RRULE_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_RRULE_PROPERTY;
    pro.valueKind = ICAL_RECUR_VALUE;
    pro.value = [rrule getConvertRecurrenceRuleDicValue];
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    [self configRecurrenceRule];
}


- (void)setLocationExt:(WCLocation *)locationExt{
    
    if(locationExt == nil){
        [self removePropertyOfKind:ICAL_LOCATION_PROPERTY];
        [self removePropertyOfKind:ICAL_GEO_PROPERTY];
        [self removePropertyWithName:X_WC_LOCATION];
        return;
    }
    
    if(locationExt.loc == nil || locationExt.geo == nil){
        
        if(!locationExt.loc){
            [self removePropertyOfKind:ICAL_LOCATION_PROPERTY];
        }
        if(!locationExt.geo){
            [self removePropertyOfKind:ICAL_GEO_PROPERTY];
        }
        
        if(!locationExt.loc && !locationExt.geo){
            [self removePropertyWithName:X_WC_LOCATION];
        }
        return;
    }
    
    
    [locationExt.loc write];
    [locationExt.geo write];
    
    BOOL isHasLocation = NO;
    NSMutableArray* properties = nil;
    if(!self.locationExt.loc || [self.locationExt.loc isValid:locationExt.loc]){
        [self removePropertyOfKind:ICAL_LOCATION_PROPERTY];
        properties = [NSMutableArray arrayWithArray:self.properties];
        [properties addObject:locationExt.loc];
        isHasLocation = YES;
    }
    
    self.properties = [properties copy];
    
    if(!self.locationExt.geo || [self.locationExt.geo isValid:locationExt.geo]){
        [self removePropertyOfKind:ICAL_GEO_PROPERTY];
        properties = [NSMutableArray arrayWithArray:self.properties];
        [properties addObject:locationExt.geo];
    }
    self.properties = [properties copy];
    
    if(isHasLocation){
        [self removePropertyWithName:X_WC_LOCATION];
        properties = [NSMutableArray arrayWithArray:self.properties];
        NSError* error = nil;
        NSData *x_wc_locationData = [NSJSONSerialization dataWithJSONObject:locationExt.x_wc_location options:NSJSONWritingPrettyPrinted error:&error];
        NSString* x_wc_location = nil;
        if(!error){
            x_wc_location = [[NSString alloc] initWithData:x_wc_locationData encoding:NSUTF8StringEncoding];
            x_wc_location = [NSString stringByEscapingMetacharacters:x_wc_location];
        }
        WCProperty* pro = [[WCProperty alloc] init];
        pro.kind = ICAL_X_PROPERTY;
        pro.valueKind = ICAL_X_VALUE;
        pro.value = x_wc_location;
        pro.propertyName = X_WC_LOCATION;
        [properties addObject:pro];
    }
    
    self.properties = [properties copy];
    
    _locationExt = locationExt;
}


- (void)setAdvance:(NSString *)advance{
    
    if(!advance || (advance && advance.length<= 0)){
        [self removePropertyWithName:X_WC_ADVANCE];
        return;
    }
    if([advance isEqualToString:_advance]){
        return;
    }
    [self removePropertyWithName:X_WC_ADVANCE];
    
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_X_PROPERTY;
    pro.valueKind = ICAL_X_VALUE;
    pro.value = advance;
    pro.propertyName = X_WC_ADVANCE;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];

    _advance = (NSString*)[self firstPropertyWithName:X_WC_ADVANCE].value;
}

- (void)setIsRing:(NSInteger)isRing{
    
    if(isRing == _isRing){
        [self removePropertyWithName:X_WC_ISRING];
        return;
    }
    [self removePropertyWithName:X_WC_ISRING];
    
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_X_PROPERTY;
    pro.valueKind = ICAL_X_VALUE;
    pro.value = [NSString stringWithFormat:@"%zd",isRing];
    pro.propertyName = X_WC_ISRING;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    _isRing = [((NSString*)[self firstPropertyWithName:X_WC_ISRING].value) integerValue];
}

- (void)setDateCreated:(NSDate *)dateCreated{
    if(!dateCreated){
        return;
    }
    if([self.dateCreated isEqualToDate:dateCreated]){
        return;
    }
    [self removePropertyOfKind:ICAL_CREATED_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_CREATED_PROPERTY;
    pro.valueKind = ICAL_DATETIME_VALUE;
    pro.value = dateCreated;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    _dateCreated = (NSDate *)[[self firstPropertyOfKind:ICAL_CREATED_PROPERTY] value];
}


- (void)setDateLastModified:(NSDate *)dateLastModified{
    if(!dateLastModified){
        return;
    }
    if([self.dateLastModified isEqualToDate:dateLastModified]){
        return;
    }
    [self removePropertyOfKind:ICAL_LASTMODIFIED_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_LASTMODIFIED_PROPERTY;
    pro.valueKind = ICAL_DATETIME_VALUE;
    pro.value = dateLastModified;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    _dateLastModified = (NSDate *)[[self firstPropertyOfKind:ICAL_LASTMODIFIED_PROPERTY] value];
    
}

- (void)setUrl:(NSString *)url{
    if(!url || (url && url.length <= 0)){
        [self removePropertyOfKind:ICAL_URL_PROPERTY];
        return;
    }
    if([self.url isEqualToString:url]){
        return;
    }
    [self removePropertyOfKind:ICAL_URL_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_URL_PROPERTY;
    pro.valueKind = ICAL_URI_VALUE;
    pro.value = url;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    _url = (NSString *)[[self firstPropertyOfKind:ICAL_URL_PROPERTY] value];
}

- (void)setStatus:(NSString *)status{
    
    if(!status || (status && status.length <= 0)){
        [self removePropertyOfKind:ICAL_STATUS_PROPERTY];
        return;
    }
    if([self.status isEqualToString:status]){
        return;
    }
    [self removePropertyOfKind:ICAL_STATUS_PROPERTY];
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_STATUS_PROPERTY;
    pro.valueKind = ICAL_STATUS_VALUE;
    pro.value = status;
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:pro];
    self.properties = [properties copy];
    
    _status = (NSString *)[[self firstPropertyOfKind:ICAL_STATUS_PROPERTY] value];
}

- (void)setAttendees:(NSArray *)attendees{
    
    if(!attendees || attendees.count <= 0){
        [self removePropertyOfKind:ICAL_ATTENDEE_PROPERTY];
        [self removePropertyWithName:X_WC_PERSON];
        return;
    }
    [self removePropertyOfKind:ICAL_ATTENDEE_PROPERTY];
    [self removePropertyWithName:X_WC_PERSON];
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObjectsFromArray:attendees];

    NSMutableArray* persons = [[NSMutableArray alloc] init];
    for (WCPerson* person in attendees) {
        [persons addObject:person.x_wc_person];
    }

    NSError* error = nil;
    NSData *x_wc_personData = [NSJSONSerialization dataWithJSONObject:persons options:NSJSONWritingPrettyPrinted error:&error];
    NSString* x_wc_person = nil;
    if(!error){
        x_wc_person = [[NSString alloc] initWithData:x_wc_personData encoding:NSUTF8StringEncoding];
        x_wc_person = [NSString stringByEscapingMetacharacters:x_wc_person];
    }
    
    WCProperty* pro = [[WCProperty alloc] init];
    pro.kind = ICAL_X_PROPERTY;
    pro.valueKind = ICAL_X_VALUE;
    pro.value = x_wc_person;
    pro.propertyName = X_WC_PERSON;
    [properties addObject:pro];
    
    self.properties = [properties copy];
    
    _attendees = [self propertiesOfKind:ICAL_ATTENDEE_PROPERTY];
    for (WCPerson* person in _attendees) {
        [person read];
    }
    
}

- (void)setIsAllDay:(NSInteger)isAllDay{
    
    _isAllDay = isAllDay;
    if(_dateStart){
        [self removePropertyOfKind:ICAL_DTSTART_PROPERTY];
        WCProperty* pro = [[WCProperty alloc] init];
        pro.kind = ICAL_DTSTART_PROPERTY;
        if(!self.isAllDay){
            pro.valueKind = ICAL_DATETIME_VALUE;
        }else {
            pro.valueKind = ICAL_DATE_VALUE;
        }
        pro.value = _dateStart;
        NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
        [properties addObject:pro];
        self.properties = [properties copy];
        
        _dateStart = (NSDate *)[[self firstPropertyOfKind:ICAL_DTSTART_PROPERTY] value];
        [self configIsAllDay];
    }
    
    if(_dateEnd){
        [self removePropertyOfKind:ICAL_DTEND_PROPERTY];
        WCProperty* pro = [[WCProperty alloc] init];
        pro.kind = ICAL_DTEND_PROPERTY;
        if(!self.isAllDay){
            pro.valueKind = ICAL_DATETIME_VALUE;
        }else {
            pro.valueKind = ICAL_DATE_VALUE;
        }
        pro.value = _dateEnd;
        NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
        [properties addObject:pro];
        self.properties = [properties copy];
        
        _dateEnd = (NSDate *)[[self firstPropertyOfKind:ICAL_DTEND_PROPERTY] value];
    }
}

- (void)read{

    _dateStart = (NSDate *)[[self firstPropertyOfKind:ICAL_DTSTART_PROPERTY] value];
    _dateEnd = (NSDate *)[[self firstPropertyOfKind:ICAL_DTEND_PROPERTY] value];
    _dateStamp = (NSDate *)[[self firstPropertyOfKind:ICAL_DTSTAMP_PROPERTY] value];
    _dateCreated = (NSDate *)[[self firstPropertyOfKind:ICAL_CREATED_PROPERTY] value];
    _dateLastModified = (NSDate *)[[self firstPropertyOfKind:ICAL_LASTMODIFIED_PROPERTY] value];
    NSArray * properties =  [self propertiesOfKind:ICAL_SEQUENCE_PROPERTY];
    NSMutableArray * sequences = [NSMutableArray array];
    for (WCProperty * sequence in properties) {
        [sequences addObject:sequence.value];
    }
    _sequences = sequences;
    
    NSString* value = (NSString*)[[self firstPropertyOfKind:ICAL_UID_PROPERTY] value];
    if(!value){
        value = @"";
    }
    _UID = value;
    

    WCLocation* location = [[WCLocation alloc] init];
    WCLoc* loc = (WCLoc*)[self firstPropertyOfKind:ICAL_LOCATION_PROPERTY];
    if(!loc){
        loc = [[WCLoc alloc] init];
    }
    WCGeo* geo = (WCGeo*)[self firstPropertyOfKind:ICAL_GEO_PROPERTY];
    if(!geo){
        geo = [[WCGeo alloc] init];
    }
    [loc read];
    [geo read];
    location.geo = geo;
    location.loc = loc;
    
    NSString*  x_wc_location = (NSString*)[self firstPropertyWithName:X_WC_LOCATION].value;
    if(x_wc_location && x_wc_location.length > 0){
        x_wc_location = [NSString stringByEscapingMetacharacters:x_wc_location];
        NSError* error = nil;
        NSDictionary * x_wc_locations = [NSJSONSerialization JSONObjectWithData:[x_wc_location dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if(!error){
            location.x_wc_location = x_wc_locations;
        }
    }
    
    _locationExt = location;
    

    value = (NSString*)[[self firstPropertyOfKind:ICAL_SUMMARY_PROPERTY] value];
    if(!value){
        value = @"";
    }
    _summary = value;
    
    value = (NSString*)[[self firstPropertyOfKind:ICAL_STATUS_PROPERTY] value];
    if(!value){
        value = @"TENTATIVE";
    }
    _status = value;
    
    value = (NSString*)[[self firstPropertyOfKind:ICAL_URL_PROPERTY] value];
    if(!value){
        value = @"";
    }
    _url = value;
    
    value = (NSString*)[[self firstPropertyOfKind:ICAL_DESCRIPTION_PROPERTY] value];
    if(!value){
        value = @"";
    }
    _desc = value;
    _organizer = (WCPerson *)[self firstPropertyOfKind:ICAL_ORGANIZER_PROPERTY];
    _attendees = [self propertiesOfKind:ICAL_ATTENDEE_PROPERTY];
    
    for (WCPerson* person in _attendees) {
        [person read];
    }
    
    
    NSString*  x_wc_person = (NSString*)[self firstPropertyWithName:X_WC_PERSON].value;
    if(x_wc_person && x_wc_person.length > 0){
        
        x_wc_person = [NSString stringByEscapingMetacharacters:x_wc_person];
        NSError* error = nil;
        NSArray * x_wc_persons = [NSJSONSerialization JSONObjectWithData:[x_wc_person dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if(!error){
            for(NSDictionary* personDic in x_wc_persons){
                WCPerson* person = [self person:personDic[@"person_email"] withName:personDic[@"person_display_name"]];
                if(person){
                    person.x_wc_person = personDic;
                }
            }
        }
    }
    
    _advance = (NSString*)[self firstPropertyWithName:X_WC_ADVANCE].value;
    if(_advance && _advance.length > 0){
        _advance = [NSString stringByEscapingMetacharacters:_advance];
    }
    _isRing = [(NSString*)[self firstPropertyWithName:X_WC_ISRING].value integerValue];
    
    
    [self configRecurrenceRule];
    [self configIsAllDay];
}


#pragma mark  maker
+ (WCEvent*)wc_makeEvent:(WCEventMakerBlock)block{
    
    NSParameterAssert(block);
    WCEventMaker* maker = [[WCEventMaker alloc] init];
    block(maker);
    return [maker make];
}

- (void)wc_updateEvent:(WCEventMakerBlock)block{
    NSParameterAssert(block);
    WCEventMaker* maker = [[WCEventMaker alloc] init];
    [maker update:self];
    block(maker);
}

- (BOOL)locationIsURLValueKind{
    WCProperty* pro = [self firstPropertyOfKind:ICAL_LOCATION_PROPERTY];
    if(pro){
        if(pro.valueKind == ICAL_URI_VALUE){
            return YES;
        }
    }
    return NO;
    
}

#pragma private methods
- (void)configRecurrenceRule{
    WCProperty* property = [self firstPropertyOfKind:ICAL_RRULE_PROPERTY];
    NSString* rrlueString = [property stringForRecurrence];
    _rrule = [[WCRecurrenceRule alloc] initWithRecurrenceRuleString:rrlueString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    comps = [calendar components:unitFlags fromDate:_dateStart];
    _rrule.eventSyear = comps.year;
    _rrule.eventSmonth = comps.month;
    _rrule.eventSday = comps.day;
}

- (void)configIsAllDay{
    WCProperty* datePro= [self firstPropertyOfKind:ICAL_DTSTART_PROPERTY];
    if(datePro.valueKind == ICAL_DATE_VALUE){
        _isAllDay = 1;
    }else if(datePro.valueKind == ICAL_DATETIME_VALUE){
        _isAllDay = 0;
    }else {
        _isAllDay = 0;
    }
}

- (WCPerson*)person:(NSString*)email withName:(NSString*)name{
    
    for(WCPerson* person in self.attendees){
    
        if((person.name && name && [person.name isEqualToString:name])
           && (person.email && email && [person.email isEqualToString:[@"Mailto:" stringByAppendingString:email]])){
            return person;
        }
    }
    return nil;
}


static NSString * mailto = @"mailto";
-(NSString *) stringFixUpEmail: email {
    
    if ([email hasPrefix:mailto]) {
        return email;
    }
    return [NSString stringWithFormat:@"mailto:%@", email];
}

-(NSString *) stringInviteResponse: (WCInviteResponse) response  {
    switch (response) {
        case WCInviteResponseAccept:
            return @"ACCEPT";
            break;
        case WCInviteResponseDecline:
            return @"DECLINE";
            break;
        case WCInviteResponseTenative:
            return @"TENATIVE";
            break;
        case WCInviteResponseUnknown:
        default:
            return @"UNKNOWN";
            break;
    }
}

-(WCInviteResponse) responseInviteFromString: (NSString *) status {

  if ([status isEqualToString:@"ACCEPT"] || [status isEqualToString:@"ACCEPTED"] || [status isEqualToString:@"YES"]) {
    return WCInviteResponseAccept;
  }
  if ([status isEqualToString:@"DECLINE"] || [status isEqualToString:@"DECLINED"] || [status isEqualToString:@"NO"]) {
    return WCInviteResponseDecline;
  }
  if ([status isEqualToString:@"TENATIVE"] || [status isEqualToString:@"TENATIVED"] || [status isEqualToString:@"MAYBE"]) {
    return WCInviteResponseTenative;
  }

    return WCInviteResponseUnknown;
}

- (void) updateAttendeeWithEmail: (NSString *) email withResponse: (WCInviteResponse) response {
    NSArray  * attendees = self.attendees;
    for (WCProperty * attendee in  attendees) {
        
        if ([(NSString *)attendee.value isEqualToString:[self stringFixUpEmail:email]]) {
            NSMutableDictionary * parameters = [attendee.parameters mutableCopy];
            
            parameters[@"PARTSTAT"] = [self stringInviteResponse:response];
            
            attendee.parameters = [NSDictionary dictionaryWithDictionary:parameters];
        }
    }
}


- (WCInviteResponse) lookupAttendeeStatusForEmail: (NSString *) email {
  NSArray  * attendees = self.attendees;
  for (WCProperty * attendee in  attendees) {

    if ([(NSString *)attendee.value isEqualToString:[self stringFixUpEmail:email]]) {

      NSDictionary * parameters = attendee.parameters;

      return [self responseInviteFromString: parameters[@"PARTSTAT"]];
    }
  }
  return WCInviteResponseUnknown;
}


@end


