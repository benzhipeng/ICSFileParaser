
//
//  WCComponent.h
//

#import <Foundation/Foundation.h>
#import "ical.h"

@class WCZoneDirectory;
@class WCProperty;

@interface WCComponent : NSObject

@property (nonatomic, strong) NSArray * subcomponents;

@property (nonatomic, strong) NSArray * properties;

@property (nonatomic, assign) icalcomponent_kind kind;


+(instancetype)componentWithIcalComponent: (icalcomponent *) c;

+(instancetype) componentWithString: (NSString *) content;

- (NSArray *) propertiesOfKind: (icalproperty_kind) kind;

-(WCProperty *) firstPropertyOfKind: (icalproperty_kind) kind;

- (WCProperty*)firstPropertyWithName:(NSString*)propertyName;

- (NSArray *) componentsOfKind: (icalcomponent_kind) kind;

-(instancetype) firstComponentOfKind: (icalcomponent_kind) kind;

-(icalcomponent *) icalBuildComponent;


- (void)removePropertyOfKind: (icalproperty_kind) kind;


- (void)removePropertyWithName:(NSString*)propertyName;

-(NSString *) stringSerializeComponent;

@end
