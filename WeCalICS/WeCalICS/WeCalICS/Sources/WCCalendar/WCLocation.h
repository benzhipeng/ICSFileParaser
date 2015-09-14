//
//  WCLocation.h
//  WeCalICS
//
//  Created by zhipeng ben on 28/8/2015.
//  Copyright (c) 2015年 ZhiPeng Ben. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WCProperty.h"


@interface WCGeo : WCProperty
@property (nonatomic,assign) CGFloat lon;
@property (nonatomic,assign) CGFloat lat;

- (BOOL)isValid:(WCGeo*)geo;

- (void)read;

- (void)write;
@end

@interface WCLoc : WCProperty
@property (nonatomic,copy) NSString* url;
@property (nonatomic,copy) NSString* des;

- (BOOL)isValid:(WCLoc*)loc;

- (void)read;

- (void)write;

@end


@interface WCLocation : NSObject
@property (nonatomic,strong) WCGeo*  geo;
@property (nonatomic,strong) WCLoc*  loc;
@property (nonatomic,copy) NSDictionary* x_wc_location;


+ (instancetype)lon:(CGFloat)lon lat:(CGFloat)lat des:(NSString*)des url:(NSString*)url;
@end
