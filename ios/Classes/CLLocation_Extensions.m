//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "CLLocation_Extensions.h"

@implementation CLLocation (CLLocation_Extension)
- (NSDictionary *)toDictionary {
    return @{
            @"latitude": @(self.coordinate.latitude),
            @"longitude": @(self.coordinate.longitude),
            @"timestamp": @([CLLocation currentTimeInMilliSeconds:self.timestamp]),
            @"altitude": @(self.altitude),
            @"accuracy": @(self.horizontalAccuracy),
            @"speed": @(self.speed),
            @"speed_accuracy": @0.0,
    };
}

+ (double)currentTimeInMilliSeconds:(NSDate *)dateToConvert {
    NSTimeInterval since1970 = [dateToConvert timeIntervalSince1970];
    return since1970 * 1000;
}
@end