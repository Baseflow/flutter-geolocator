#import <CoreLocation/CoreLocation.h>
#import "GeolocatorPlugin.h"
#import "Constants/ErrorCodes.h"
#import "Handlers/GeolocationHandler.h"
#import "Handlers/PermissionHandler.h"
#import "Handlers/PositionStreamHandler.h"
#import "Utils/AuthorizationStatusMapper.h"
#import "Utils/LocationAccuracyMapper.h"
#import "Utils/LocationDistanceMapper.h"
#import "Utils/LocationMapper.h"
#import "Handlers/LocationAccuracyHandler.h"
#import "Handlers/LocationServiceStreamHandler.h"

@interface GeolocatorPlugin()
@property (strong, nonatomic) GeolocationHandler *geolocationHandler;
@property (strong, nonatomic) PermissionHandler *permissionHandler;
@property (strong, nonatomic) LocationAccuracyHandler *locationAccuracyHandler;
@end

@implementation GeolocatorPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel *methodChannel = [FlutterMethodChannel
                                         methodChannelWithName:@"flutter.baseflow.com/geolocator"
                                         binaryMessenger:registrar.messenger];
  FlutterEventChannel *positionUpdatesEventChannel = [FlutterEventChannel
                                                      eventChannelWithName:@"flutter.baseflow.com/geolocator_updates"
                                                      binaryMessenger:registrar.messenger];
  
  FlutterEventChannel *locationServiceUpdatesEventChannel = [FlutterEventChannel eventChannelWithName:@"flutter.baseflow.com/geolocator_service_updates" binaryMessenger:registrar.messenger];
  
  GeolocatorPlugin *instance = [[GeolocatorPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:methodChannel];
  
  PositionStreamHandler *positionStreamHandler = [[PositionStreamHandler alloc] initWithGeolocationHandler:instance.geolocationHandler
                                                                                         PermissionHandler:instance.permissionHandler];
  
  LocationServiceStreamHandler *locationServiceStreamHandler = [[LocationServiceStreamHandler alloc] init];
  
  instance.locationAccuracyHandler = [[LocationAccuracyHandler alloc] init];
  
  [locationServiceUpdatesEventChannel setStreamHandler:locationServiceStreamHandler];
  [positionUpdatesEventChannel setStreamHandler:positionStreamHandler];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"checkPermission" isEqualToString:call.method]) {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    result([AuthorizationStatusMapper toDartIndex:(status)]);
  } else if ([@"requestPermission" isEqualToString:call.method]) {
    [self onRequestPermission:result];
  } else if ([@"isLocationServiceEnabled" isEqualToString:call.method]) {
    BOOL isEnabled = [CLLocationManager locationServicesEnabled];
    result([NSNumber numberWithBool:isEnabled]);
  } else if ([@"getLastKnownPosition" isEqualToString:call.method]) {
    [self onGetLastKnownPosition:result];
  } else if ([@"getCurrentPosition" isEqualToString:call.method]) {
    [self onGetCurrentPositionWithArguments:call.arguments
                                     result:result];
  } else if([@"getLocationAccuracy" isEqualToString:call.method]) {
    [self.locationAccuracyHandler getLocationAccuracyWithResult:result];
  } else if([@"requestTemporaryFullAccuracy" isEqualToString:call.method]) {
    NSString* purposeKey = (NSString *)call.arguments[@"purposeKey"];
    [self.locationAccuracyHandler requestTemporaryFullAccuracyWithResult:result
                                                               purposeKey:purposeKey];
  } else if ([@"openAppSettings" isEqualToString:call.method]) {
    [self openSettings:result];
  } else if ([@"openLocationSettings" isEqualToString:call.method]) {
    [self openSettings:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)onRequestPermission:(FlutterResult)result {
  [self.permissionHandler
   requestPermission:^(CLAuthorizationStatus status) {
    result([AuthorizationStatusMapper toDartIndex:status]);
  }
   errorHandler:^(NSString *errorCode, NSString *errorDescription) {
    result([FlutterError errorWithCode: errorCode
                               message: errorDescription
                               details: nil]);
  }];
}

- (void)onGetLastKnownPosition:(FlutterResult)result {
  __weak typeof(self) weakSelf = self;
  
  [self.permissionHandler
   requestPermission:^(CLAuthorizationStatus status) {
    if (status != kCLAuthorizationStatusAuthorizedWhenInUse && status != kCLAuthorizationStatusAuthorizedAlways) {
      result([FlutterError errorWithCode: GeolocatorErrorPermissionDenied
                                 message: @"User denied permissions to access the device's location."
                                 details:nil]);
      return;
    }
    
    CLLocation *location = [weakSelf.geolocationHandler getLastKnownPosition];
    result([LocationMapper toDictionary:location]);
  }
   errorHandler:^(NSString *errorCode, NSString *errorDescription) {
    result([FlutterError errorWithCode: errorCode
                               message: errorDescription
                               details: nil]);
  }];
}

- (void)onGetCurrentPositionWithArguments:(id _Nullable)arguments
                                   result:(FlutterResult)result {
  [self.permissionHandler
   requestPermission:^(CLAuthorizationStatus status) {
    if (status != kCLAuthorizationStatusAuthorizedWhenInUse && status != kCLAuthorizationStatusAuthorizedAlways) {
      result([FlutterError errorWithCode: GeolocatorErrorPermissionDenied
                                 message: @"User denied permissions to access the device's location."
                                 details:nil]);
      return;
    }
    
    CLLocationAccuracy accuracy = [LocationAccuracyMapper toCLLocationAccuracy:(NSNumber *)arguments[@"accuracy"]];
    CLLocationDistance distanceFilter = [LocationDistanceMapper toCLLocationDistance:(NSNumber *)arguments[@"distanceFilter"]];
    GeolocationHandler *geolocationHandler = [[GeolocationHandler alloc] init];
    
    [geolocationHandler startListeningWithDesiredAccuracy:accuracy
                                           distanceFilter:distanceFilter
                                            resultHandler:^(CLLocation *location) {
      [geolocationHandler stopListening];
      
      result([LocationMapper toDictionary:location]);
    }
                                             errorHandler:^(NSString *errorCode, NSString *errorDescription){
      [geolocationHandler stopListening];
      
      result([FlutterError errorWithCode: errorCode
                                 message: errorDescription
                                 details: nil]);
    }];
  }
   errorHandler:^(NSString *errorCode, NSString *errorDescription) {
    result([FlutterError errorWithCode: errorCode
                               message: errorDescription
                               details: nil]);
  }];
}

- (void)openSettings:(FlutterResult)result {
  if (@available(iOS 10, *)) {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
     options:[[NSDictionary alloc] init]
     completionHandler:^(BOOL success) {
      result([[NSNumber alloc] initWithBool:success]);
    }];
  } else if (@available(iOS 8.0, *)) {
    BOOL success = [[UIApplication sharedApplication]
                    openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    result([[NSNumber alloc] initWithBool:success]);
  } else {
    result([[NSNumber alloc] initWithBool:NO]);
  }
}

- (GeolocationHandler *) geolocationHandler {
  if (!_geolocationHandler) {
    _geolocationHandler = [[GeolocationHandler alloc] init];
  }
  return _geolocationHandler;
}

- (PermissionHandler *) permissionHandler {
  if (!_permissionHandler) {
    _permissionHandler = [[PermissionHandler alloc] init];
  }
  return _permissionHandler;
}
@end
