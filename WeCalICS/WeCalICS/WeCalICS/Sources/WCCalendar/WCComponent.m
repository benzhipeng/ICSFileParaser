//
//  WCComponent.m
//

#import "WCComponent.h"
#import "WCCalendar.h"
#import "WCEvent.h"
#import "WCProperty.h"
#import "WCZoneDirectory.h"


@interface WCComponent ()


@end

@implementation WCComponent

+(void) initialize {
    [WCZoneDirectory sharedZoneDirectory];
}

+ (instancetype) componentFactory: (icalcomponent *) c {
    WCComponent * component;
    switch ( icalcomponent_isa(c)) {
        case ICAL_VCALENDAR_COMPONENT:
            component = [[WCCalendar alloc] init];
            break;
            
        case ICAL_VEVENT_COMPONENT:
            component = [[WCEvent alloc] init];
            break;
            
        default:
            component = [[WCComponent alloc]init];
            break;
    }
    return component;
}

+(instancetype)componentWithIcalComponent: (icalcomponent *) c {
    
    icalcomponent_strip_errors(c); //去除所有不合法的数据
    WCComponent * component = [WCComponent componentFactory: c];

    if (component) {
        component.kind = icalcomponent_isa(c);
        NSMutableArray * propertyList = [[NSMutableArray alloc] init];
        NSMutableArray * childComponentList = [[NSMutableArray alloc] init];
        icalproperty* p = icalcomponent_get_first_property(c, ICAL_ANY_PROPERTY);
        
        while (p) {
            
            WCProperty * property = [WCProperty propertyWithIcalProperty: p];
            
            if (property) {
                [propertyList addObject:property];
            }
            
            p = icalcomponent_get_next_property(c, ICAL_ANY_PROPERTY);
            
        }
        
        component.properties = [NSArray arrayWithArray: propertyList];
        
        icalcomponent * child_c = icalcomponent_get_first_component(c, ICAL_ANY_COMPONENT);
        
        while (child_c) {
            
            WCComponent * childComponent = [WCComponent componentWithIcalComponent:child_c];
            
            if (childComponent) {
                [childComponentList addObject: childComponent];
            }
            child_c = icalcomponent_get_next_component(c,ICAL_ANY_COMPONENT);
        }
        
        component.subcomponents = [NSArray arrayWithArray: childComponentList];
        
    }
    
    return component;
}

+(instancetype) componentWithString: (NSString *) content {
    icalcomponent *root = icalparser_parse_string([content cStringUsingEncoding:NSUTF8StringEncoding]);
    
    WCComponent * component;
    
    if (root) {
        component = [WCComponent componentWithIcalComponent: root];
        
        icalcomponent_free(root);
    }
    return component;
}

- (NSArray *) propertiesOfKind: (icalproperty_kind) kind {
    NSMutableArray * results =[[NSMutableArray alloc] init];
    
    for (WCProperty * property in self.properties) {
        if (property.kind == kind) {
            [results addObject: property];
        }
    }
    
    return results;
}

- (void)removePropertyOfKind: (icalproperty_kind) kind{
    
    NSArray * results = [self  propertiesOfKind: kind];
    icalcomponent* comp = [self icalBuildComponent];
    for(WCProperty* pro in results){
        icalcomponent_remove_property(comp, [pro icalBuildProperty]);
    }
    NSMutableArray* ps = [[NSMutableArray alloc] initWithArray:self.properties];
    [ps removeObjectsInArray:results];
    self.properties = [ps copy];
}

- (void)removePropertyWithName:(NSString*)propertyName{
    
    WCProperty*  findPropety = [self firstPropertyWithName:propertyName];
    if(findPropety){
        icalcomponent* comp = [self icalBuildComponent];
        icalcomponent_remove_property(comp, [findPropety icalBuildProperty]);
        
        NSMutableArray* ps = [[NSMutableArray alloc] initWithArray:self.properties];
        [ps removeObject:findPropety];
        self.properties = [ps copy];
    }
}

-(WCProperty *) firstPropertyOfKind: (icalproperty_kind) kind {
    NSArray * results = [self  propertiesOfKind: kind];
    if (results.count > 0) {
        return results[0];
    }
    return nil;
}

- (WCProperty*)firstPropertyWithName:(NSString*)propertyName{
    WCProperty*  findPropety = nil;
    for (WCProperty * property in self.properties) {
        if ([property.propertyName isEqualToString:propertyName]) {
            findPropety = property;
            break;
        }
    }
    return findPropety;
}


- (NSArray *) componentsOfKind: (icalcomponent_kind) kind {
    NSMutableArray * results =[[NSMutableArray alloc] init];
    
    for (WCComponent * component in self.subcomponents) {
        if (component.kind == kind) {
            [results addObject: component];
        }
    }
    
    return results;
}

-(instancetype) firstComponentOfKind: (icalcomponent_kind) kind {
    NSArray * results = [self  componentsOfKind: kind];
    if (results.count > 0) {
        return results[0];
    }
    return nil;
}



#pragma mark - Output

-(icalcomponent *) icalBuildComponent {
    
    icalcomponent * ical_component = NULL;
    ical_component = icalcomponent_new(self.kind);
    for (WCProperty * property in self.properties) {
        icalproperty * ical_property = [property icalBuildProperty];
        icalcomponent_add_property(ical_component, ical_property);
    }
    for (WCComponent * component in self.subcomponents) {
        icalcomponent * child_ical_component = [component icalBuildComponent];
        icalcomponent_add_component(ical_component, child_ical_component);
    }
    return ical_component;
}

-(NSString *) stringSerializeComponent {
    NSString * buffer  = @"";
    icalcomponent *root = [self icalBuildComponent];
    
    char * _buffer = icalcomponent_as_ical_string(root);
    
    buffer = [buffer stringByAppendingString:[NSString stringWithCString:_buffer encoding:NSUTF8StringEncoding]];
    
    return buffer;
}

#pragma mark - NSObject Overides
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> Key: %d",
            NSStringFromClass([self class]), self, self.kind];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    WCComponent *object = [[[self class] allocWithZone:zone] init];
    object.kind = self.kind;
    
    if (object) {
        object.subcomponents = [[NSArray alloc] initWithArray: self.subcomponents copyItems:YES];
        object.properties = [[NSArray alloc] initWithArray: self.properties copyItems:YES];
    }
    
    return object;
}

-(BOOL) isEqual: (WCComponent *) component {
    
    if (self.kind != component.kind) {
        return NO;
    }
    
    if (self.properties.count != component.properties.count) {
        return NO;
    }
    
    for (NSUInteger index = 0 ; index < self.properties.count; index ++) {
        if (! [self.properties[index] isEqual: component.properties[index]]) {
            return NO;
        }
    }
    
    
    if (self.subcomponents.count != component.subcomponents.count) {
        return NO;
    }
    
    for (NSUInteger index = 0 ; index < self.subcomponents.count; index ++) {
        
        if (![self.subcomponents[index] isEqual:
                               component.subcomponents[index]]) {
            return NO;
        }
    }
    return YES;
    
}
@end
