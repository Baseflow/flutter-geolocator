#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

#import "CalculateDistanceTask.h"
#import "GeocodeTask.h"
#import "LastKnownLocationTask.h"
#import "LocationTask.h"
#import "TaskProtocol.h"
#import "Task.h"

@interface GeolocatorPlugin : NSObject <FlutterPlugin, FlutterStreamHandler, CLLocationManagerDelegate>
@end
