#import "GeolocatorPlugin.h"
#import <geolocator/geolocator-Swift.h>

@implementation GeolocatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGeolocatorPlugin registerWithRegistrar:registrar];
}
@end
