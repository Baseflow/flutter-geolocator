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

@property(assign, nonatomic) bool requestingCurrentLocation;

@property(strong, nonatomic, nonnull) CLLocationManager *locationManager;

@property(strong, nonatomic) GeolocatorError errorHandler;

@property(strong, nonatomic) GeolocatorResult resultHandler;

@end

@implementation GeolocationHandler

- (id) init {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  
  self.requestingCurrentLocation = NO;
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

- (CLLocation *)getLastKnownPosition {
  CLLocationManager *locationManager = [self getLocationManager];
  return [locationManager location];
}

- (void)requestPositionWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                             resultHandler:(GeolocatorResult _Nonnull)resultHandler
                              errorHandler:(GeolocatorError _Nonnull)errorHandler {
  self.errorHandler = errorHandler;
  self.resultHandler = resultHandler;
  
  [self startUpdatingLocationWithDesiredAccuracy:desiredAccuracy
                                  distanceFilter:kCLDistanceFilterNone
               pauseLocationUpdatesAutomatically:NO
                                    activityType:CLActivityTypeOther
                       requestingCurrentLocation:YES
                 showBackgroundLocationIndicator:NO];
}

- (void)startListeningWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                           distanceFilter:(CLLocationDistance)distanceFilter
        pauseLocationUpdatesAutomatically:(BOOL)pauseLocationUpdatesAutomatically
          showBackgroundLocationIndicator:(BOOL)showBackgroundLocationIndicator
                             activityType:(CLActivityType)activityType
                            resultHandler:(GeolocatorResult _Nonnull )resultHandler
                             errorHandler:(GeolocatorError _Nonnull)errorHandler {
    
  self.errorHandler = errorHandler;
  self.resultHandler = resultHandler;
    
  [self startUpdatingLocationWithDesiredAccuracy:desiredAccuracy
                                  distanceFilter:distanceFilter
               pauseLocationUpdatesAutomatically:pauseLocationUpdatesAutomatically
                                    activityType:activityType
                       requestingCurrentLocation:NO
                 showBackgroundLocationIndicator:showBackgroundLocationIndicator];
}

- (void)startUpdatingLocationWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                                  distanceFilter:(CLLocationDistance)distanceFilter
               pauseLocationUpdatesAutomatically:(BOOL)pauseLocationUpdatesAutomatically
                                    activityType:(CLActivityType)activityType
                       requestingCurrentLocation:(BOOL)requestingCurrentLocation
                 showBackgroundLocationIndicator:(BOOL)showBackgroundLocationIndicator{
  self.requestingCurrentLocation = requestingCurrentLocation;
  CLLocationManager *locationManager = [self getLocationManager];
  locationManager.desiredAccuracy = desiredAccuracy;
  locationManager.distanceFilter = distanceFilter;
  if (@available(iOS 6.0, macOS 10.15, *)) {
    locationManager.activityType = activityType;
    locationManager.pausesLocationUpdatesAutomatically = pauseLocationUpdatesAutomatically;
  }
  
#if TARGET_OS_IOS
  if (@available(iOS 9.0, macOS 11.0, *)) {
    locationManager.allowsBackgroundLocationUpdates = [GeolocationHandler shouldEnableBackgroundLocationUpdates];
  }
  if (@available(iOS 11.0, macOS 11.0, *)) {
    locationManager.showsBackgroundLocationIndicator = showBackgroundLocationIndicator;
  }
#endif
  
  [locationManager startUpdatingLocation];
}

- (void)stopListening {
  [[self getLocationManager] stopUpdatingLocation];
  
  self.errorHandler = nil;
  self.resultHandler = nil;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
  if (!self.resultHandler) return;

  CLLocation *mostRecentLocation = [locations lastObject];
  NSTimeInterval ageInSeconds = -[mostRecentLocation.timestamp timeIntervalSinceNow];
  // If location is older then 5.0 seconds it is likely a cached location which
  // will be skipped.
  if (self.requestingCurrentLocation && ageInSeconds > kMaxLocationLifeTimeInSeconds) {
    return;
  }
    
  if ([locations lastObject]) {
    self.resultHandler(mostRecentLocation);
  }
  
  if (self.requestingCurrentLocation) {
    [self stopListening];
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
  
  if (self.requestingCurrentLocation) {
    [self stopListening];
  }
}

+ (BOOL) shouldEnableBackgroundLocationUpdates {
  if (@available(iOS 9.0, *)) {
    return [[NSBundle.mainBundle objectForInfoDictionaryKey:@"UIBackgroundModes"] containsObject: @"location"];
  } else {
    return NO;
  }
}
@end
