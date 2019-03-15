//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "LocationTask.h"


@implementation LocationTask {
    LocationOptions *_locationOptions;
    CLLocationManager *_locationManager;
}

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super initWithContext:context completionHandler:completionHandler];
    if (self) {
        _locationOptions = [[LocationOptions alloc] initWithArguments:context.arguments];
    }
    
    return self;
}

- (void)startTask {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    CLLocationAccuracy accuracy = [self clValue:_locationOptions.accuracy];
    CLLocationDistance distanceFilter = _locationOptions.distanceFilter;
    
    _locationManager.desiredAccuracy = accuracy;
    _locationManager.distanceFilter = distanceFilter;
    
    NSLog(@"%d", [_locationManager locationServicesEnabled]);
    [_locationManager startUpdatingLocation];
}


- (void)stopTask {
    if (_locationManager != nil) {
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
    
    [super stopTask];
}

- (CLLocationAccuracy)clValue:(GeolocationAccuracy)accuracy {
    switch (accuracy) {
        case GeolocationAccuracyLowest:
            return kCLLocationAccuracyThreeKilometers;
        case GeolocationAccuracyLow:
            return kCLLocationAccuracyKilometer;
        case GeolocationAccuracyMedium:
            return kCLLocationAccuracyHundredMeters;
        case GeolocationAccuracyHigh:
            return kCLLocationAccuracyNearestTenMeters;
        case GeolocationAccuracyBest:
            return kCLLocationAccuracyBest;
        case GeolocationAccuracyBestForNavigation:
            return kCLLocationAccuracyBestForNavigation;
        default:
            return 0.0;
    }
}
@end


@implementation CurrentLocationTask

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%s", sel_getName(_cmd));
    if ([locations lastObject]) {
        CLLocation *location = [locations lastObject];
        NSDictionary *positionDict = [location toDictionary];
        
        [[self context] resultHandler](positionDict);
        [self stopTask];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s", sel_getName(_cmd));
    [[self context] resultHandler]([FlutterError errorWithCode:@"ERROR_UPDATING_LOCATION" message:error.localizedDescription details:nil]);
    [self stopTask];
}

@end


@implementation StreamLocationUpdatesTask

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([locations lastObject]) {
        CLLocation *location = [locations lastObject];
        NSDictionary *positionDict = [location toDictionary];
        
        [[self context] resultHandler](positionDict);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [[self context] resultHandler]([FlutterError errorWithCode:@"ERROR_UPDATING_LOCATION" message:error.localizedDescription details:nil]);
    [self stopTask];
}

@end
