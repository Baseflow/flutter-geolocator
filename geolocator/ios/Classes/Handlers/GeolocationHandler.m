//
//  LocationManager.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/06/2020.
//

#import "GeolocationHandler.h"
#import "PermissionHandler.h"
#import "../Constants/ErrorCodes.h"

@interface GeolocationHandler() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) GeolocatorError errorHandler;
@property (assign, nonatomic) GeolocatorResult resultHandler;

@end

@implementation GeolocationHandler

- (CLLocation *)getLastKnownPosition {
    return [self.locationManager location];
}

- (CLLocationManager *) locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}
@end
