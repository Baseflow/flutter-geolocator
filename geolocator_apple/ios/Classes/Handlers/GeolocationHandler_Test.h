// This header is available in the Test module. Import via "@import geolocator_apple.Test;"

#import <CoreLocation/CoreLocation.h>

/// Methods exposed for unit testing.
@interface GeolocationHandler(Test) <CLLocationManagerDelegate>

/// Overrides the CLLocationManager instance used by the GeolocationHandler.
/// This should only be used for testing purposes.
- (void)setLocationManagerOverride:(CLLocationManager *)locationManager;

@end
