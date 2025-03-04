#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

@interface GeolocatorPlugin : NSObject<FlutterPlugin>
@end
