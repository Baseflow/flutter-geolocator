//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "CalculateDistanceTask.h"


@implementation CalculateDistanceTask {
    CLLocation *_startLocation;
    CLLocation *_endLocation;
}

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super initWithContext:context completionHandler:completionHandler];
    if (self) {
        //
        [self parseCoordinates:context.arguments];
    }

    return self;
}

- (void)parseCoordinates:(id)arguments {
    if ([arguments isMemberOfClass:[NSDictionary class]]) {
        NSDictionary<NSString *, NSNumber *> *location = [[NSDictionary alloc] initWithDictionary:arguments];
        CLLocationDegrees startLatitude = location[@"startLatitude"].doubleValue;
        CLLocationDegrees startLongitude = location[@"startLongitude"].doubleValue;
        CLLocationDegrees endLatitude = location[@"endLatitude"].doubleValue;
        CLLocationDegrees endLongitude = location[@"endLongitude"].doubleValue;

        _startLocation = [[CLLocation alloc] initWithLatitude:startLatitude longitude:startLongitude];
        _endLocation = [[CLLocation alloc] initWithLatitude:endLatitude longitude:endLongitude];
    } else {
        _startLocation = nil;
        _endLocation = nil;
    }
}

- (void)startTask {
    if (_startLocation == nil || _endLocation == nil) {
        [self handleErrorCode:@"ERROR_CALCULATE_DISTANCE_INVALID_PARAMS" message:@"Please supply start and end coordinates."];
        [self stopTask];
        return;
    }

    CLLocationDistance distance = [_endLocation distanceFromLocation:_startLocation];

    [[self context] resultHandler](@(distance));
    [self stopTask];
}

@end