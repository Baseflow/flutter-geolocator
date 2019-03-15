//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "LocationOptions.h"


@implementation LocationOptions
- (instancetype)init {
    self = [super init];
    if (self) {
        self.accuracy = GeolocationAccuracyBest;
        self.distanceFilter = 0;
    }

    return self;
}


- (instancetype)initWithAccuracy:(GeolocationAccuracy)accuracy distanceFilter:(CLLocationDistance)distanceFilter {
    self = [super init];
    if (self) {
        self.accuracy = accuracy;
        self.distanceFilter = distanceFilter;
    }

    return self;
}

- (instancetype)initWithArguments:(id)arguments {
    self = [super init];
    if (self) {
        NSDictionary *args = arguments;

        NSNumber *accuracy = args[@"accuracy"];
        NSNumber *distanceFilter = args[@"distanceFilter"];

        self.accuracy = (GeolocationAccuracy) accuracy.intValue;
        self.distanceFilter = distanceFilter.doubleValue;
    }

    return self;
}

@end
