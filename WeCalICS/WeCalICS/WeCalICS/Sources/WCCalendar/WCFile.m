//
//  WCFile.m
//

#import "WCFile.h"


@interface WCFile ()

@property (nonatomic, copy) NSString * pathname;

@property (nonatomic, strong) WCComponent *icsFileRoot;

@end

@implementation WCFile


- (instancetype)initWithPathname:(NSString *)pathname {
    
    self = [super init];
    if (self) {
        self.pathname = pathname;
    
        
        //TODO: Need to check this is configured properly
        
    }
    
    return self;
    
}


+ (instancetype)fileWithPathname:(NSString *)pathname {
    
    return [[WCFile alloc]initWithPathname:pathname];
    
}


- (WCComponent *) read {

    NSString * caldata = [NSString stringWithContentsOfFile:self.pathname
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    
    if (caldata) {
        
        icalcomponent *root = icalparser_parse_string([caldata cStringUsingEncoding:NSUTF8StringEncoding]);
   
        if (root) {
            self.icsFileRoot = [WCComponent componentWithIcalComponent: root];

            icalcomponent_free(root);
        }
    }
    return self.icsFileRoot;
}


- (BOOL) writeVCalendar: (WCCalendar *) vCalendar {
    
    NSString * buffer = [vCalendar stringSerializeComponent];
    
    NSError * error;
    if (![buffer writeToFile:self.pathname atomically:YES  encoding: NSUTF8StringEncoding error: &error]) {
        NSLog(@"Error: %@",error);
        return NO;
    }
    
    return YES;
}



#pragma mark - NSObject Overides
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> Pathname: %@", NSStringFromClass([self class]), self, self.pathname];
}

- (id)copyWithZone:(NSZone *)zone {
    WCFile *object = [[[self class] allocWithZone:zone] init];
    
    if (object) {
        object.pathname = [self.pathname copyWithZone:zone];
        object.icsFileRoot = [self.pathname copyWithZone:zone];
    }
    
    return object;
}

@end
