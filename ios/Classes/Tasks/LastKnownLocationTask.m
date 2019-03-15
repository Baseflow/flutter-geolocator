//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "LastKnownLocationTask.h"


@implementation LastKnownLocationTask

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super initWithContext:context completionHandler:completionHandler];
    if (self) {
        //
    }

    return self;
}

- (void)startTask {
    CLLocationManager *locationManager = [CLLocationManager new];
    CLLocation *location = [locationManager location];

    if (location == nil) {
        [[self context] resultHandler](nil);
        return;
    }

    [[self context] resultHandler]([location toDictionary]);
    [self stopTask];
}

@end