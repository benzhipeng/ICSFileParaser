//
//  WCLocation.m
//  WeCalICS
//
//  Created by zhipeng ben on 28/8/2015.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//

#import "WCLocation.h"

@implementation WCGeo

- (id)init{
    if(self = [super init]){
        self.kind = ICAL_GEO_PROPERTY;
        self.valueKind = ICAL_GEO_VALUE;
    }
    return self;
}

- (void)read{
    if(self.value){
        NSDictionary* geoPosition = (NSDictionary*)self.value;
        self.lat = [geoPosition[@"lat"] floatValue];
        self.lon = [geoPosition[@"lon"] floatValue];
    }else {
        self.lat = self.lon = 0.f;
    }
}

- (void)write{
    self.value = @{@"lat":[NSString stringWithFormat:@"%f",self.lat],@"lon":[NSString stringWithFormat:@"%f",self.lon]};
}

- (BOOL)isValid:(WCGeo*)geo{
    
    if((geo.lon <=0 && geo.lat <= 0)
       || (self.lon == geo.lon && self.lat == geo.lat)){
        return NO;
    }
    return YES;
}
@end

@implementation WCLoc

- (id)init{
    if(self = [super init]){
        self.kind = ICAL_LOCATION_PROPERTY;
        self.valueKind = ICAL_TEXT_VALUE;
    }
    return self;
}


- (void)read{
    if(self.valueKind == ICAL_TEXT_VALUE){
        if(self.value == nil){
            self.value = @"";
        }
        self.des = (NSString*)self.value;
        self.url = @"";
    }
    
    if(self.valueKind == ICAL_URI_VALUE){
        if(self.value == nil){
            self.value = @"";
        }
        self.url = (NSString*)self.value;
        self.des = @"";
    }
}

- (void)write{
    
    if(self.url && self.url.length > 0){
        self.valueKind = ICAL_URI_VALUE;
        self.value = self.url;
    }else {
        self.valueKind = ICAL_TEXT_VALUE;
        self.value = self.des;
    }
}

- (BOOL)isValid:(WCLoc*)loc{

    if(!loc.des && !loc.url){
        return NO;
    }
    
    if((loc.des.length <= 0 || [self.des isEqualToString:loc.des])
       && (loc.url.length <= 0 || [self.url isEqualToString:loc.url])){
        return NO;
    }
    return YES;
}
@end


@implementation WCLocation

+ (instancetype)lon:(CGFloat)lon lat:(CGFloat)lat des:(NSString*)des url:(NSString*)url{
    
    WCGeo* geo = [[WCGeo alloc] init];
    geo.lon = lon;
    geo.lat = lat;
    
    
    WCLoc* loc = [[WCLoc alloc] init];
    loc.des = des;
    loc.url = url;
    
    
    WCLocation* location = [[WCLocation alloc] init];
    location.geo = geo;
    location.loc = loc;
    return location;
}
@end
