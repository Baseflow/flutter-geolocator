//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(int, GeolocationAccuracy) {
    GeolocationAccuracyLowest = 0,
    GeolocationAccuracyLow,
    GeolocationAccuracyMedium,
    GeolocationAccuracyHigh,
    GeolocationAccuracyBest,
    GeolocationAccuracyBestForNavigation,
};

@interface LocationOptions : NSObject
@property GeolocationAccuracy accuracy;
@property CLLocationDistance distanceFilter;

- (instancetype)initWithAccuracy:(GeolocationAccuracy)accuracy distanceFilter:(CLLocationDistance)distanceFilter;

- (instancetype)initWithArguments:(id)arguments;
@end
