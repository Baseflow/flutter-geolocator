//
//  LocationManager.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/06/2020.
//

#import "GeolocationHandler.h"
#import "GeolocationHandler_Test.h"
#import "../Constants/ErrorCodes.h"

double const kMaxLocationLifeTimeInSeconds = 5.0;

@interface GeolocationHandler() <CLLocationManagerDelegate>

@property(strong, nonatomic, nonnull) CLLocationManager *locationManager;
@property(strong, nonatomic) GeolocatorError errorHandler;

@property(strong, nonatomic, nonnull) CLLocationManager *oneTimeLocationManager;
@property(strong, nonatomic) GeolocatorError oneTimeErrorHandler;

@property(strong, nonatomic) GeolocatorResult currentLocationResultHandler;
@property(strong, nonatomic) GeolocatorResult listenerResultHandler;

@end

@implementation GeolocationHandler

- (id) init {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  
  return self;
}

- (CLLocationManager *) getLocationManager {
  if (!self.locationManager) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  }
  return self.locationManager;
}

- (void)setLocationManagerOverride:(CLLocationManager *)locationManager {
  self.locationManager = locationManager;
}

- (CLLocationManager *) getOneTimeLocationManager {
  if (!self.oneTimeLocationManager) {
    self.oneTimeLocationManager = [[CLLocationManager alloc] init];
    self.oneTimeLocationManager.delegate = self;
  }
  return self.oneTimeLocationManager;
}

- (void)setOneTimeLocationManagerOverride:(CLLocationManager *)locationManager {
  self.oneTimeLocationManager = locationManager;
}

- (CLLocation *) getLastKnownPosition {
  CLLocationManager *locationManager = [self getLocationManager];
  CLLocation *cashedLocation = [locationManager location];
  if (cashedLocation != nil) {
    return cashedLocation;
  }
  CLLocationManager *persistentLocationManager = [self getOneTimeLocationManager];
  return [persistentLocationManager location];
}

- (void)requestPositionWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                             resultHandler:(GeolocatorResult _Nonnull)resultHandler
                              errorHandler:(GeolocatorError _Nonnull)errorHandler {
  self.oneTimeErrorHandler = errorHandler;
  self.currentLocationResultHandler = resultHandler;
  
  BOOL showBackgroundLocationIndicator = NO;
  BOOL allowBackgroundLocationUpdates = NO;
  
  [self startUpdatingLocationWithDesiredAccuracy:desiredAccuracy
                                  distanceFilter:kCLDistanceFilterNone
               pauseLocationUpdatesAutomatically:NO
                                    activityType:CLActivityTypeOther
                   isListeningForPositionUpdates:NO
                 showBackgroundLocationIndicator:showBackgroundLocationIndicator
                  allowBackgroundLocationUpdates:allowBackgroundLocationUpdates];
}

- (void)startListeningWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                           distanceFilter:(CLLocationDistance)distanceFilter
        pauseLocationUpdatesAutomatically:(BOOL)pauseLocationUpdatesAutomatically
          showBackgroundLocationIndicator:(BOOL)showBackgroundLocationIndicator
                             activityType:(CLActivityType)activityType
           allowBackgroundLocationUpdates:(BOOL)allowBackgroundLocationUpdates
                            resultHandler:(GeolocatorResult _Nonnull )resultHandler
                             errorHandler:(GeolocatorError _Nonnull)errorHandler {
  
  self.errorHandler = errorHandler;
  self.listenerResultHandler = resultHandler;
  
  [self startUpdatingLocationWithDesiredAccuracy:desiredAccuracy
                                  distanceFilter:distanceFilter
               pauseLocationUpdatesAutomatically:pauseLocationUpdatesAutomatically
                                    activityType:activityType
                   isListeningForPositionUpdates:YES
                 showBackgroundLocationIndicator:showBackgroundLocationIndicator
                  allowBackgroundLocationUpdates:allowBackgroundLocationUpdates];
}

- (void)startUpdatingLocationWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                                  distanceFilter:(CLLocationDistance)distanceFilter
               pauseLocationUpdatesAutomatically:(BOOL)pauseLocationUpdatesAutomatically
                                    activityType:(CLActivityType)activityType
                   isListeningForPositionUpdates:(BOOL)isListeningForPositionUpdates
                 showBackgroundLocationIndicator:(BOOL)showBackgroundLocationIndicator
                  allowBackgroundLocationUpdates:(BOOL)allowBackgroundLocationUpdates
{
  
  if (isListeningForPositionUpdates) {
    CLLocationManager *locationManager = [self getLocationManager];
    locationManager.desiredAccuracy = desiredAccuracy;
    locationManager.distanceFilter = distanceFilter;
    if (@available(iOS 6.0, macOS 10.15, *)) {
      locationManager.activityType = activityType;
      locationManager.pausesLocationUpdatesAutomatically = pauseLocationUpdatesAutomatically;
    }
    
#if TARGET_OS_IOS
    locationManager.allowsBackgroundLocationUpdates = allowBackgroundLocationUpdates
    && [GeolocationHandler shouldEnableBackgroundLocationUpdates];
    locationManager.showsBackgroundLocationIndicator = showBackgroundLocationIndicator;
#endif
    [locationManager startUpdatingLocation];
  } else {
    CLLocationManager *locationManager = [self getOneTimeLocationManager];
    locationManager.desiredAccuracy = desiredAccuracy;
    locationManager.distanceFilter = distanceFilter;
    [locationManager startUpdatingLocation];
  }
}

- (void)stopOneTimeLocationListening {
  [[self getOneTimeLocationManager] stopUpdatingLocation];
  self.oneTimeErrorHandler = nil;
  self.currentLocationResultHandler = nil;
}

- (void)stopListening {
    [[self getLocationManager] stopUpdatingLocation];
    self.errorHandler = nil;
    self.listenerResultHandler = nil;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
  if (!self.listenerResultHandler && !self.currentLocationResultHandler) return;
  
  CLLocation *mostRecentLocation = [locations lastObject];
  NSTimeInterval ageInSeconds = -[mostRecentLocation.timestamp timeIntervalSinceNow];
  // If location is older then 5.0 seconds it is likely a cached location which
  // will be skipped.
  if (manager == [self getOneTimeLocationManager] && ageInSeconds > kMaxLocationLifeTimeInSeconds) {
    return;
  }
  
  if ([locations lastObject]) {
    if (self.currentLocationResultHandler != nil) {
      self.currentLocationResultHandler(mostRecentLocation);
    }
    if (self.listenerResultHandler != nil) {
      self.listenerResultHandler(mostRecentLocation);
    }
  }
  
  self.currentLocationResultHandler = nil;
  if (manager == [self getOneTimeLocationManager]) {
    [self stopOneTimeLocationListening];
  }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(nonnull NSError *)error {
  NSLog(@"LOCATION UPDATE FAILURE:"
        "Error reason: %@"
        "Error description: %@", error.localizedFailureReason, error.localizedDescription);
  
  if([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorLocationUnknown) {
    return;
  }
  
  if (self.errorHandler) {
    self.errorHandler(GeolocatorErrorLocationUpdateFailure, error.localizedDescription);
  }
  
  if (self.oneTimeErrorHandler) {
    self.oneTimeErrorHandler(GeolocatorErrorLocationUpdateFailure, error.localizedDescription);
  }
  
  if (manager == [self getOneTimeLocationManager]) {
    [self stopOneTimeLocationListening];
  }
}

+ (BOOL) shouldEnableBackgroundLocationUpdates {
  return [[NSBundle.mainBundle objectForInfoDictionaryKey:@"UIBackgroundModes"] containsObject: @"location"];
}
@end
