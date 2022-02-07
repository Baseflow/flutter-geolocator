// This header is available in the Test module. Import via "@import camera.Test;"

#import <CoreLocation/CoreLocation.h>
#import <geolocator_apple/GeolocationHandler.h>

/// Methods exposed for unit testing.
@interface GeolocationHandler(Test) <CLLocationManagerDelegate>

- (void)setLocationManagerOverride:(CLLocationManager *)locationManager;

@end
