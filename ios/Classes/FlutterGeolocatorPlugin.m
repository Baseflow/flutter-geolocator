#import "FlutterGeolocatorPlugin.h"
#import <flutter_geolocator/flutter_geolocator-Swift.h>

@implementation FlutterGeolocatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterGeolocatorPlugin registerWithRegistrar:registrar];
}
@end
