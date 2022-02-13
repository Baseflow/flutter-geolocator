//
//  PermissionHandler.m
//  geolocator
//
//  Created by Maurits van Beusekom on 26/06/2020.
//

#import "PermissionHandler.h"
#import "../Constants/ErrorCodes.h"
#import "../Utils/PermissionUtils.h"

@interface PermissionHandler() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PermissionConfirmation confirmationHandler;
@property (strong, nonatomic) PermissionError errorHandler;

@end

@implementation PermissionHandler

- (CLLocationManager *) getLocationManager {
  if (!self.locationManager) {
    self.locationManager = [[CLLocationManager alloc] init];
  }
  
  return self.locationManager;
}

- (BOOL) hasPermission {
  CLAuthorizationStatus status = [self checkPermission];
  
  return [PermissionUtils isStatusGranted:status];
}

- (CLAuthorizationStatus) checkPermission {
  if (@available(iOS 14, macOS 11, *)) {
    return [self.getLocationManager authorizationStatus];
  } else {
    return [CLLocationManager authorizationStatus];
  }
}

- (void) requestPermission:(PermissionConfirmation)confirmationHandler
              errorHandler:(PermissionError)errorHandler {
  // When we already have permission we don't have to request it again
  CLAuthorizationStatus authorizationStatus = CLLocationManager.authorizationStatus;
  if (authorizationStatus != kCLAuthorizationStatusNotDetermined) {
    confirmationHandler(authorizationStatus);
    return;
  }
  
  if (self.confirmationHandler) {
    // Permission request is already running, return immediatly with error
    errorHandler(GeolocatorErrorPermissionRequestInProgress,
                 @"A request for location permissions is already running, please wait for it to complete before doing another request.");
    return;
  }
  
  self.confirmationHandler = confirmationHandler;
  self.errorHandler = errorHandler;
  CLLocationManager *locationManager = [self getLocationManager];
  locationManager.delegate = self;
  
#if TARGET_OS_OSX
  if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationUsageDescription"] != nil) {
    if (@available(macOS 10.15, *)) {
      [locationManager requestAlwaysAuthorization];
    }
  }
#else
  if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil) {
    [locationManager requestWhenInUseAuthorization];
  }
  else if ([self containsLocationAlwaysDescription]) {
    [locationManager requestAlwaysAuthorization];
  }
#endif
  else {
    if (self.errorHandler) {
      self.errorHandler(GeolocatorErrorPermissionDefinitionsNotFound,
                        @"Permission definitions not found in the app's Info.plist. Please make sure to "
                        "add either NSLocationWhenInUseUsageDescription or "
                        "NSLocationAlwaysUsageDescription to the app's Info.plist file on iOS. If running on macOS please add NSLocationUsageDescription to the app's Info.plist file.");
    }
    
    [self cleanUp];
    return;
  }
}

- (BOOL) containsLocationAlwaysDescription {
  BOOL containsAlwaysDescription = NO;
  if (@available(iOS 11.0, *)) {
    containsAlwaysDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUseUsageDescription"] != nil;
  }
  
  return containsAlwaysDescription
  ? containsAlwaysDescription
  : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusNotDetermined) {
    return;
  }
  
  if (self.confirmationHandler) {
    self.confirmationHandler(status);
  }
  
  [self cleanUp];
}

- (void) cleanUp {
  self.locationManager = nil;
  self.errorHandler = nil;
  self.confirmationHandler = nil;
}
@end
