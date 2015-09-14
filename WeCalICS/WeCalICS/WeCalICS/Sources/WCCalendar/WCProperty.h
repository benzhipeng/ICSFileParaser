//
//  WCProperty.h
//
#import "ical.h"
#import <Foundation/Foundation.h>
@interface WCProperty : NSObject

@property (nonatomic, copy) NSString*  propertyName;
@property (nonatomic, copy) NSObject * value;
@property (nonatomic, copy) NSDictionary * parameters;
@property (nonatomic, assign) icalproperty_kind kind;
@property (nonatomic, assign) icalvalue_kind valueKind;

+(instancetype) propertyWithIcalProperty: (icalproperty *) p;

-(icalproperty *) icalBuildProperty ;

- (NSString*)stringForRecurrence;
@end
