// This header is available in the Test module. Import via "@import geolocator_apple.Test;"

#import <geolocator_apple/GeolocationHandler.h>
#import <geolocator_apple/LocationAccuracyHandler.h>
#import <geolocator_apple/PermissionHandler.h>

/// Methods exposed for unit testing.
@interface GeolocatorPlugin(Test)

/// Overrides the GeolocationHandler instance used by the GeolocatorPlugin.
/// This should only be used for testing purposes.
- (void)setGeolocationHandlerOverride:(GeolocationHandler *)geolocationHandler;

/// Overrides the LocationAccuracyHandler instance used by the GeolocatorPlugin.
/// This should only be used for testing purposes.
- (void)setLocationAccuracyHandlerOverride:(LocationAccuracyHandler *)locationAccuracyHandler;

/// Overrides the PermissionHandler instance used by the GeolocatorPlugin.
/// This should only be used for testing purposes.
- (void)setPermissionHandlerOverride:(PermissionHandler *)permissionHandler;

@end
