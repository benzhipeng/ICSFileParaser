//
//  WCCalendar.m
//

#import "WCCalendar.h"
#import "WCFile.h"
#import "WCProperty.h"
#import "WCEvent.h"

@implementation WCCalendar

#pragma mark - public Methods
+ (WCCalendar*)wc_makeCalendar:(WCCalendarMakerBlock)block{
    
    NSParameterAssert(block);
    WCCalendarMaker* maker = [[WCCalendarMaker alloc] init];
    WCCalendar* calendar = [maker make];
    block(maker);
    return calendar;
}

- (void)wc_updateCalendar:(WCCalendarMakerBlock)block{
    NSParameterAssert(block);
    WCCalendarMaker* maker = [[WCCalendarMaker alloc] init];
    [maker update:self];
    block(maker);

}

+ (void)calendarParaser:(NSString*)content events:(void(^)(NSArray* events))events{
    
    WCCalendar* calendar = [WCCalendar calendarWithString:content];
    if(calendar){
         NSMutableArray* eventArray = [[NSMutableArray alloc] initWithCapacity:0];
        [[calendar componentsOfKind:ICAL_VEVENT_COMPONENT] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WCEvent* event = (WCEvent*)obj;
            [event read];
            [eventArray addObject:event];
        }];
        events([eventArray copy]);
    }else {
        events(nil);
    }
}

+ (WCCalendar*)calendarWithString:(NSString*)content{
    WCComponent *  component  = [WCComponent componentWithString:content];
    WCCalendar* calendar = [WCCalendar calendarfromCompnent:component];
    return calendar;
}

- (WCEvent*)eventWithUID:(NSString*)uid{
    NSArray* comps = [self componentsOfKind:ICAL_VEVENT_COMPONENT];
    for(WCEvent* event in comps){
        [event read];
        if([event.UID isEqualToString:uid]){
            return event;
        }
    }
    return nil;
}


#pragma mark  private Methods
+(instancetype) calendarfromCompnent: (WCComponent *) component {
    if (component.kind ==ICAL_XROOT_COMPONENT) {
        component = [component firstComponentOfKind:ICAL_VCALENDAR_COMPONENT];
    }
    
    if (component.kind != ICAL_VCALENDAR_COMPONENT) {
        NSLog(@"Unexpected Component in ICS File");
        return nil;
    }
    
    if (![[(WCCalendar *)component version] isEqualToString:@"2.0"] ) {
        NSLog(@"Unexpected ICS File Version");
        return nil;
    }
    return (WCCalendar *) component;
}

#pragma mark - Custom Accessors

-(NSString *) method {
    return (NSString *)[[self firstPropertyOfKind:ICAL_METHOD_PROPERTY] value];
}

-(void) setMethod: (NSString *) newMethod {
    WCProperty * property = [[WCProperty alloc] init];
    property.kind = ICAL_METHOD_PROPERTY;
    property.valueKind = ICAL_METHOD_VALUE;
    property.value = [newMethod copy];
    
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:property];
    self.properties = [properties copy];
}


-(NSString *) version {
    NSArray * properties = [self propertiesOfKind:ICAL_VERSION_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"Version Error");
        return nil;
    }
    return (NSString *)[((WCProperty *)properties[0]) value];
}

- (void)setVersion:(NSString *)version{
    WCProperty * property = [[WCProperty alloc] init];
    property.kind = ICAL_VERSION_PROPERTY;
    property.valueKind = ICAL_TEXT_VALUE;
    property.value = [version copy];
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:property];
    self.properties = [properties copy];
}


- (NSString*)provide{
    
    WCProperty* pro = [self firstPropertyOfKind:ICAL_PRODID_PROPERTY];
    return (NSString *)[pro value];
}

- (void)setProvide:(NSString *)provide{
    
    WCProperty * property = [[WCProperty alloc] init];
    property.kind = ICAL_PRODID_PROPERTY;
    property.valueKind = ICAL_TEXT_VALUE;
    property.value = [provide copy];
    NSMutableArray* properties = [NSMutableArray arrayWithArray:self.properties];
    [properties addObject:property];
    self.properties = [properties copy];
    
}
@end
