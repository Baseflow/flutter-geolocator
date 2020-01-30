//
//  LocationTask.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import "LocationTask.h"


@implementation LocationTask {
    LocationOptions *_locationOptions;
}

- (void)dealloc {
    NSLog(@"[LocationTask %s]", sel_getName(_cmd));
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
}

- (void)stopTask {
    if (_locationManager != nil) {
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
    
    [super stopTask];
}

- (void)locationManager:(CLLocationManager *)manager  didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%s", sel_getName(_cmd));
    if ([locations lastObject]) {
        CLLocation *location = [locations lastObject];
        NSDictionary *positionDict = [location toDictionary];
        
        [[self context] resultHandler](positionDict);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s", sel_getName(_cmd));
    if([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorLocationUnknown) {
        return;
    }
    
    [[self context] resultHandler]([FlutterError errorWithCode:@"ERROR_UPDATING_LOCATION" message:error.localizedDescription details:@(error.code)]);
    [self stopTask];
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

- (void)dealloc {
    NSLog(@"[CurrentLocationTask %s]", sel_getName(_cmd));
}

- (void)startTask {
    [super startTask];
    
    [_locationManager requestWhenInUseAuthorization];
    
    if (@available(iOS 9.0, *)) {
        [_locationManager requestLocation];
    } else {
        [_locationManager startUpdatingLocation];
    }
}
	
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [super locationManager:manager didUpdateLocations:locations];
    [self stopTask];
}

@end


@implementation StreamLocationUpdatesTask

- (void)dealloc {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)startTask {
    [super startTask];
    
    [_locationManager startUpdatingLocation];
}

@end
