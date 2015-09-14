//
//  WCPerson.m
//

#import "WCPerson.h"

@implementation WCPerson

- (id)init{
    if(self = [super init]){
        self.kind = ICAL_ATTENDEE_PROPERTY;
        self.valueKind = ICAL_CALADDRESS_VALUE;
    }
    return self;
}
-(BOOL) RSVP {
    NSString * value = self.parameters[@"RSVP"];
    return [value isEqualToString:@"TRUE"] ||
           [value isEqualToString:@"1"];
}


- (void)read{
    
    if(self.value){_email = [NSString stringWithFormat:@"%@",self.value];};
    if(self.parameters[@"CN"]){
        _name= self.parameters[@"CN"];
    }
    if(self.parameters[@"ROLE"]){
        _role = self.parameters[@"ROLE"];
    }
    if(self.parameters[@"PARTSTAT"]){
        _partstat = self.parameters[@"PARTSTAT"];
    }
}


- (void)setEmail:(NSString *)email{
    
    if(email){
        NSString* value = [@"Mailto:" stringByAppendingString:email];
        self.value = value;
    }
}

- (void)setName:(NSString *)name{

    if(name){
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:self.parameters];
        [params setObject:name forKey:@"CN"];
        self.parameters = params;
    }
}


- (void)setPartstat:(NSString *)partstat{
    if(partstat){
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:self.parameters];
        [params setObject:partstat forKey:@"PARTSTAT"];
        self.parameters = params;
    }
}

- (void)setRole:(NSString *)role{
    if(role){
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:self.parameters];
        [params setObject:role forKey:@"ROLE"];
        self.parameters = params;
    }
}

+ (instancetype)personWithEmailAndName:(NSString*)email name:(NSString*)name{
    WCPerson* person = [[WCPerson alloc] init];
    person.name = name;
    person.email = email;
    return person;
}

@end
