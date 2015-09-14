//
//  WCZoneDirectory.m
//  WCCal
//
//  Created by Andrew Halls on 6/9/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import "ical.h"
#import "WCZoneDirectory.h"


@implementation WCZoneDirectory
#pragma mark Singleton Methods

+ (id)sharedZoneDirectory {
    static WCZoneDirectory *sharedZoneDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedZoneDirectory = [[self alloc] init];
    });
    return sharedZoneDirectory;
}

- (id)init {
    if (self = [super init]) {
        NSBundle *pluginBundle = [NSBundle mainBundle];
        NSString *zoneinfoPath = [NSString stringWithFormat: @"%@/zoneinfo", [pluginBundle resourcePath]];
        set_zone_directory((char *)[zoneinfoPath cStringUsingEncoding:NSUTF8StringEncoding]);

    }
    return self;
}
@end
