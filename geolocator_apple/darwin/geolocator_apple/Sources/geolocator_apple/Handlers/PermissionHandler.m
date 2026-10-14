//
//  PermissionHandler.m
//  geolocator
//
//  Created by Maurits van Beusekom on 26/06/2020.
//

#import "../include/geolocator_apple/Handlers/PermissionHandler.h"
#import "../include/geolocator_apple/Constants/ErrorCodes.h"
#import "../include/geolocator_apple/Utils/PermissionUtils.h"
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

@interface PermissionHandler() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PermissionConfirmation confirmationHandler;
@property (strong, nonatomic) PermissionError errorHandler;
@property (assign, nonatomic) BOOL isWaitingForPermission;

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
  self.isWaitingForPermission = YES;
  CLLocationManager *locationManager = [self getLocationManager];
  locationManager.delegate = self;

#if TARGET_OS_IOS
  // Register for app lifecycle notifications to handle dialog dismissal
  // When user locks phone or backgrounds app while permission dialog is showing,
  // iOS dismisses the dialog without calling the delegate. We need to detect this
  // and resolve the Future to prevent it from hanging indefinitely.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationDidBecomeActive:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
#endif

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
#if !BYPASS_PERMISSION_LOCATION_ALWAYS
  else if ([self containsLocationAlwaysDescription]) {
    [locationManager requestAlwaysAuthorization];
  }
#endif
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

#if !BYPASS_PERMISSION_LOCATION_ALWAYS
- (BOOL) containsLocationAlwaysDescription {
  BOOL containsAlwaysDescription = NO;
  if (@available(iOS 11.0, *)) {
    containsAlwaysDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUseUsageDescription"] != nil;
  }
  
  return containsAlwaysDescription
  ? containsAlwaysDescription
  : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
}
#endif

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusNotDetermined) {
    // Dialog is being shown or was just dismissed without user action.
    // Don't resolve yet - wait for actual user decision or app lifecycle event.
    return;
  }

  // User has made a decision, resolve the callback
  if (self.confirmationHandler) {
    self.confirmationHandler(status);
  }

  [self cleanUp];
}

#if TARGET_OS_IOS
/// Called when app returns to foreground after being backgrounded or device was unlocked.
/// This handles the case where iOS dismisses the permission dialog when the app goes to background.
/// Without this, the Future would hang indefinitely waiting for a delegate callback that never comes.
- (void)applicationDidBecomeActive:(NSNotification *)notification {
  // Only process if we're actually waiting for a permission response
  if (!self.isWaitingForPermission || !self.confirmationHandler) {
    return;
  }

  // Small delay to allow any pending authorization status changes to be processed
  // The system may have queued the authorization callback before this notification
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // Double-check we're still waiting (delegate might have been called in the meantime)
    if (!self.isWaitingForPermission || !self.confirmationHandler) {
      return;
    }

    // Check current authorization status
    CLAuthorizationStatus currentStatus = [self checkPermission];

    // If status is still NotDetermined, the dialog was dismissed without user action
    // (e.g., user locked phone, switched apps, etc.)
    // Resolve with current status to prevent Future from hanging
    if (self.confirmationHandler) {
      self.confirmationHandler(currentStatus);
    }

    [self cleanUp];
  });
}
#endif

- (void) cleanUp {
#if TARGET_OS_IOS
  // Remove app lifecycle observer
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIApplicationDidBecomeActiveNotification
                                                object:nil];
#endif
  self.isWaitingForPermission = NO;
  self.locationManager = nil;
  self.errorHandler = nil;
  self.confirmationHandler = nil;
}

- (void)dealloc {
#if TARGET_OS_IOS
  [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}

@end
