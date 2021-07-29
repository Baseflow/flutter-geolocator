//
//  PositionStreamHandler.m
//  geolocator
//
//  Created by Maurits van Beusekom on 04/06/2021.
//

#import "PositionStreamHandler.h"
#import "../Constants/ErrorCodes.h"
#import "../Utils/LocationAccuracyMapper.h"
#import "../Utils/LocationDistanceMapper.h"
#import "../Utils/LocationMapper.h"

@interface PositionStreamHandler()
  @property (strong, nonatomic, nonnull) GeolocationHandler *geolocationHandler;
  @property (strong, nonatomic, nonnull) PermissionHandler *permissionHandler;
@end

@implementation PositionStreamHandler {
  FlutterEventSink _eventSink;
}

- (id) initWithGeolocationHandler: (GeolocationHandler * _Nonnull)geolocationHandler
                PermissionHandler: (PermissionHandler * _Nonnull)permissionHandler {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  self.geolocationHandler = geolocationHandler;
  self.permissionHandler = permissionHandler;
  
  return self;
}

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)eventSink {
  // When there is already an instance of the _eventSink it means there is already an active stream and
  // return an error indicating the active stream.
  if (_eventSink) {
      return [FlutterError errorWithCode: GeolocatorErrorLocationSubscriptionActive
                                 message: @"Already listening for location updates. If you want to restart listening please cancel other subscriptions first."
                                 details: nil];
  }
  _eventSink = eventSink;
  
  __weak typeof(self) weakSelf = self;
  
  [_permissionHandler
   requestPermission:^(CLAuthorizationStatus status) {
      if (status != kCLAuthorizationStatusAuthorizedWhenInUse && status != kCLAuthorizationStatusAuthorizedAlways) {
          [weakSelf onLocationFailureWithErrorCode: GeolocatorErrorPermissionDenied
                                  errorDescription: @"User denied permissions to access the device's location."];
          return;
      }
      
      CLLocationAccuracy accuracy = [LocationAccuracyMapper toCLLocationAccuracy:(NSNumber *)arguments[@"accuracy"]];
      CLLocationDistance distanceFilter = [LocationDistanceMapper toCLLocationDistance:(NSNumber *)arguments[@"distanceFilter"]];
      
      [[weakSelf geolocationHandler] startListeningWithDesiredAccuracy:accuracy
                                                    distanceFilter:distanceFilter
                                                     resultHandler:^(CLLocation *location) {
          [weakSelf onLocationDidChange: location];
      }
                                                      errorHandler:^(NSString *errorCode, NSString *errorDescription){
          [weakSelf onLocationFailureWithErrorCode:errorCode
                              errorDescription:errorDescription];
      }];
  }
   errorHandler:^(NSString *errorCode, NSString *errorDescription) {
      [weakSelf onLocationFailureWithErrorCode:errorCode
                              errorDescription:errorDescription];
  }];
  
  return nil;
}

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
    [_geolocationHandler stopListening];
    _eventSink = nil;
    
    return nil;
}

- (void)onLocationDidChange:(CLLocation *_Nullable)location {
    if (!_eventSink) return;
    
    _eventSink([LocationMapper toDictionary:location]);
}

- (void)onLocationFailureWithErrorCode:(NSString *_Nonnull)errorCode
                      errorDescription:(NSString *_Nonnull)errorDescription {
    if (!_eventSink) return;
    
    _eventSink([FlutterError errorWithCode:errorCode
                                   message:errorDescription
                                   details:nil]);
    _eventSink = nil;
}

@end
