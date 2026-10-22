//
//  LocationManager.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/06/2020.
//

#import "../include/geolocator_apple/Handlers/GeolocationHandler.h"
#import "../include/geolocator_apple/Handlers/GeolocationHandler_Test.h"
#import "../include/geolocator_apple/Constants/ErrorCodes.h"

double const kMaxLocationLifeTimeInSeconds = 5.0;

// How long a single position request keeps waiting after Core Location reports
// `kCLErrorLocationUnknown` before it gives up. The error is transient while
// updates run continuously, but `getCurrentPosition` expects one answer:
// without a deadline it never completes when the position cannot be determined
// at all (for example on a Mac with Wi-Fi turned off).
//
// The period has to outlast the Wi-Fi scan interval of macOS. Without a recent
// position, locationd reports `kCLErrorLocationUnknown` right away and only
// finds a position at its next scheduled Wi-Fi scan, every 300 seconds, so a
// working Mac can take minutes to answer. A shorter period would fail requests
// that would still succeed. Apps that want a bounded wait keep using
// `LocationSettings.timeLimit`.
double const kLocationUnknownGracePeriodInSeconds = 360.0;

@interface GeolocationHandler() <CLLocationManagerDelegate>

@property(strong, nonatomic, nonnull) CLLocationManager *locationManager;
@property(strong, nonatomic) GeolocatorError errorHandler;

@property(strong, nonatomic, nonnull) CLLocationManager *oneTimeLocationManager;

// The handlers of every pending single position request, in the order they
// were made. Requests made while another one is still running share its
// location updates, and all of them complete with the same position or error.
@property(strong, nonatomic, nonnull) NSMutableArray<GeolocatorResult> *oneTimeResultHandlers;
@property(strong, nonatomic, nonnull) NSMutableArray<GeolocatorError> *oneTimeErrorHandlers;
// The most accurate accuracy asked for by the pending single position requests.
@property(nonatomic) CLLocationAccuracy oneTimeDesiredAccuracy;

@property(strong, nonatomic) GeolocatorResult listenerResultHandler;

// Changes with every single position request, so that a grace period armed
// before the latest request cannot fail the pending requests.
@property(nonatomic) NSUInteger oneTimeRequestId;
@property(nonatomic) BOOL oneTimeLocationUnknownPending;
@property(nonatomic) NSTimeInterval locationUnknownGracePeriod;

@end

@implementation GeolocationHandler

- (id) init {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  
  _locationUnknownGracePeriod = kLocationUnknownGracePeriodInSeconds;
  _oneTimeResultHandlers = [[NSMutableArray alloc] init];
  _oneTimeErrorHandlers = [[NSMutableArray alloc] init];
  
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

- (void)setLocationUnknownGracePeriodOverride:(NSTimeInterval)gracePeriod {
  self.locationUnknownGracePeriod = gracePeriod;
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
  // A request made while another one is pending joins it instead of replacing
  // its handlers, which would leave the earlier request without an answer.
  BOOL joinsPendingRequest = self.oneTimeResultHandlers.count > 0;
  [self.oneTimeResultHandlers addObject:resultHandler];
  [self.oneTimeErrorHandlers addObject:errorHandler];
  self.oneTimeDesiredAccuracy = joinsPendingRequest
    ? MIN(self.oneTimeDesiredAccuracy, desiredAccuracy)
    : desiredAccuracy;
  // A new request restarts the grace period of every pending request.
  self.oneTimeRequestId += 1;
  self.oneTimeLocationUnknownPending = NO;
  
  BOOL showBackgroundLocationIndicator = NO;
  BOOL allowBackgroundLocationUpdates = NO;
  
  [self startUpdatingLocationWithDesiredAccuracy:self.oneTimeDesiredAccuracy
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
  [self.oneTimeResultHandlers removeAllObjects];
  [self.oneTimeErrorHandlers removeAllObjects];
}

- (void)completeOneTimeRequestsWithLocation:(CLLocation *)location {
  NSArray<GeolocatorResult> *resultHandlers = [self.oneTimeResultHandlers copy];
  [self.oneTimeResultHandlers removeAllObjects];
  [self.oneTimeErrorHandlers removeAllObjects];
  for (GeolocatorResult resultHandler in resultHandlers) {
    resultHandler(location);
  }
}

- (void)failOneTimeRequestsWithDescription:(NSString *)errorDescription {
  NSArray<GeolocatorError> *errorHandlers = [self.oneTimeErrorHandlers copy];
  [self.oneTimeResultHandlers removeAllObjects];
  [self.oneTimeErrorHandlers removeAllObjects];
  for (GeolocatorError errorHandler in errorHandlers) {
    errorHandler(GeolocatorErrorLocationUpdateFailure, errorDescription);
  }
}

- (void)stopListening {
    [[self getLocationManager] stopUpdatingLocation];
    self.errorHandler = nil;
    self.listenerResultHandler = nil;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
  if (!self.listenerResultHandler && self.oneTimeResultHandlers.count == 0) return;
  
  CLLocation *mostRecentLocation = [locations lastObject];
  NSTimeInterval ageInSeconds = -[mostRecentLocation.timestamp timeIntervalSinceNow];
  // If location is older then 5.0 seconds it is likely a cached location which
  // will be skipped.
  if (manager == [self getOneTimeLocationManager] && ageInSeconds > kMaxLocationLifeTimeInSeconds) {
    return;
  }
  
  if (mostRecentLocation) {
    [self completeOneTimeRequestsWithLocation:mostRecentLocation];
    if (self.listenerResultHandler != nil) {
      self.listenerResultHandler(mostRecentLocation);
    }
  }
  
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
    // Transient while updates run continuously: the position stream keeps
    // waiting. A single position request waits a grace period, and then fails.
    if (manager == [self getOneTimeLocationManager]) {
      [self failOneTimeRequestAfterGracePeriodWithDescription:error.localizedDescription];
    }
    return;
  }
  
  if (self.errorHandler) {
    self.errorHandler(GeolocatorErrorLocationUpdateFailure, error.localizedDescription);
  }
  
  [self failOneTimeRequestsWithDescription:error.localizedDescription];
  
  if (manager == [self getOneTimeLocationManager]) {
    [self stopOneTimeLocationListening];
  }
}

- (void)failOneTimeRequestAfterGracePeriodWithDescription:(NSString *)errorDescription {
  if (self.oneTimeResultHandlers.count == 0 || self.oneTimeLocationUnknownPending) {
    return;
  }
  self.oneTimeLocationUnknownPending = YES;
  
  NSUInteger requestId = self.oneTimeRequestId;
  __weak typeof(self) weakSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.locationUnknownGracePeriod * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
    typeof(self) strongSelf = weakSelf;
    // A position arrived, or a new request restarted the grace period, in
    // the meantime.
    if (strongSelf == nil
        || strongSelf.oneTimeRequestId != requestId
        || strongSelf.oneTimeResultHandlers.count == 0) {
      return;
    }
    
    [[strongSelf getOneTimeLocationManager] stopUpdatingLocation];
    [strongSelf failOneTimeRequestsWithDescription:errorDescription];
  });
}

+ (BOOL) shouldEnableBackgroundLocationUpdates {
  return [[NSBundle.mainBundle objectForInfoDictionaryKey:@"UIBackgroundModes"] containsObject: @"location"];
}
@end
