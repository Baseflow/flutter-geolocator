//
//  LocationAccuracyHandler.m
//  geolocator
//
//  Created by Floris Smit on 18/06/2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationAccuracyHandler.h"
#import "ErrorCodes.h"

@interface LocationAccuracyHandler()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationAccuracyHandler

- (id) init {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  
  self.locationManager = [[CLLocationManager alloc] init];
  return self;
}

- (void) getLocationAccuracyWithResult:(FlutterResult)result {
#if TARGET_OS_OSX
  return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
#else
  if (@available(iOS 14, macOS 10.16, *)) {
    switch ([self.locationManager accuracyAuthorization]) {
      case CLAccuracyAuthorizationFullAccuracy:
        return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
      case CLAccuracyAuthorizationReducedAccuracy:
        return result([NSNumber numberWithInt:(LocationAccuracy)reduced]);
      default:
        // Reduced location accuracy is the default on iOS 14+ and macOS 11+.
        return result([NSNumber numberWithInt:(LocationAccuracy)reduced]);
    }
  } else {
    // Approximate location is not available, return precise location.
    return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
  }
#endif
}

- (void) requestTemporaryFullAccuracyWithResult:(FlutterResult)result purposeKey:(NSString * _Nullable)purposeKey {
  if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationTemporaryUsageDescriptionDictionary"] == nil) {
    return result([FlutterError errorWithCode:GeolocatorErrorPermissionDefinitionsNotFound
                                      message:@"The temporary accuracy dictionary key is not set in the infop.list"
                                      details:nil]);
  }
  
#if TARGET_OS_OSX
  return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
#else
  if (@available(iOS 14.0, macOS 10.16, *)) {
    [self.locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:purposeKey
                                                                       completion:^(NSError *_Nullable error) {
      if ([self.locationManager accuracyAuthorization] == CLAccuracyAuthorizationFullAccuracy) {
        return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
      } else {
        return result([NSNumber numberWithInt:(LocationAccuracy)reduced]);
      }
    }];
  } else {
    return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
  }
#endif
}

@end
