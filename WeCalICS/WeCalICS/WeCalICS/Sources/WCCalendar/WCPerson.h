//
//  WCPerson.h
//

#import "ical.h"
#import "WCProperty.h"

@interface WCPerson : WCProperty
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* role;
@property (nonatomic,strong) NSString* partstat;
@property (nonatomic,strong) NSDictionary* x_wc_person;
-(BOOL) RSVP;

- (void)read;


+ (instancetype)personWithEmailAndName:(NSString*)email name:(NSString*)name;
@end
