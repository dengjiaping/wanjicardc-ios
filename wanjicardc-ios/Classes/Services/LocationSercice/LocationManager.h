//
//  LocationManager.h
//  WanJiCard
//
//  Created by Angie on 15/9/21.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class WJModelArea;


@interface LocationManager : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D appLocation;

@property (nonatomic, strong) WJModelArea *choosedArea;
@property (nonatomic, strong, readonly) WJModelArea *currentArea;

+ (LocationManager *)sharedInstance;

- (void)initCoreLoacation;

+ (void)getSelfLocationInChina;

+ (NSString *)gpsAddress;

+ (NSError *)gpsError;

@end
