#import <CoreLocation/CoreLocation.h>
#import "GeolocatorPlugin.h"
#import "GeolocatorPlugin_Test.h"
#import "Constants/ErrorCodes.h"
#import "Handlers/GeolocationHandler.h"
#import "Handlers/PermissionHandler.h"
#import "Handlers/PositionStreamHandler.h"
#import "Utils/ActivityTypeMapper.h"
#import "Utils/AuthorizationStatusMapper.h"
#import "Utils/LocationAccuracyMapper.h"
#import "Utils/LocationDistanceMapper.h"
#import "Utils/LocationMapper.h"
#import "Utils/PermissionUtils.h"
#import "Handlers/LocationAccuracyHandler.h"
#import "Handlers/LocationServiceStreamHandler.h"

@implementation GeolocatorPlugin {
  GeolocationHandler *_geolocationHandler;
  LocationAccuracyHandler *_locationAccuracyHandler;
  PermissionHandler *_permissionHandler;
}

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
  
  PositionStreamHandler *positionStreamHandler = [[PositionStreamHandler alloc] initWithGeolocationHandler:instance.getGeolocationHandler];
  [positionUpdatesEventChannel setStreamHandler:positionStreamHandler];
  
  LocationServiceStreamHandler *locationServiceStreamHandler = [[LocationServiceStreamHandler alloc] init];
  [locationServiceUpdatesEventChannel setStreamHandler:locationServiceStreamHandler];
  
}

- (GeolocationHandler *) getGeolocationHandler {
  if (!_geolocationHandler) {
    _geolocationHandler = [[GeolocationHandler alloc] init];
  }
  return _geolocationHandler;
}

- (void) setGeolocationHandlerOverride:(GeolocationHandler *)geolocationHandler {
  _geolocationHandler = geolocationHandler;
}

- (LocationAccuracyHandler *) getLocationAccuracyHandler {
  if (!_locationAccuracyHandler) {
    _locationAccuracyHandler = [[LocationAccuracyHandler alloc] init];
  }
  return _locationAccuracyHandler;
}

- (void) setLocationAccuracyHandlerOverride:(LocationAccuracyHandler *)locationAccuracyHandler {
  _locationAccuracyHandler = locationAccuracyHandler;
}

- (PermissionHandler *) getPermissionHandler {
  if (!_permissionHandler) {
    _permissionHandler = [[PermissionHandler alloc] init];
  }
  return _permissionHandler;
}

- (void) setPermissionHandlerOverride:(PermissionHandler *)permissionHandler {
  _permissionHandler = permissionHandler;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"checkPermission" isEqualToString:call.method]) {
    [self onCheckPermission:result];
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
    [[self getLocationAccuracyHandler] getLocationAccuracyWithResult:result];
  } else if([@"requestTemporaryFullAccuracy" isEqualToString:call.method]) {
    NSString* purposeKey = (NSString *)call.arguments[@"purposeKey"];
    [[self getLocationAccuracyHandler] requestTemporaryFullAccuracyWithResult:result
                                                                   purposeKey:purposeKey];
  } else if ([@"openAppSettings" isEqualToString:call.method]) {
    [self openSettings:result];
  } else if ([@"openLocationSettings" isEqualToString:call.method]) {
    [self openSettings:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)onCheckPermission:(FlutterResult) result {
  CLAuthorizationStatus status = [[self getPermissionHandler] checkPermission];
  result([AuthorizationStatusMapper toDartIndex:status]);
}

- (void)onRequestPermission:(FlutterResult)result {
  [[self getPermissionHandler]
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
  if (![[self getPermissionHandler] hasPermission]) {
    result([FlutterError errorWithCode: GeolocatorErrorPermissionDenied
                               message:@"User denied permissions to access the device's location."
                               details:nil]);
    return;
  }
  
  CLLocation *location = [self.getGeolocationHandler getLastKnownPosition];
  result([LocationMapper toDictionary:location]);
}

- (void)onGetCurrentPositionWithArguments:(id _Nullable)arguments
                                   result:(FlutterResult)result {
  if (![[self getPermissionHandler] hasPermission]) {
    result([FlutterError errorWithCode: GeolocatorErrorPermissionDenied
                               message:@"User denied permissions to access the device's location."
                               details:nil]);
    return;
  }
  
  CLLocationAccuracy accuracy = [LocationAccuracyMapper toCLLocationAccuracy:(NSNumber *)arguments[@"accuracy"]];
  GeolocationHandler *geolocationHandler = [self getGeolocationHandler];
  
  [geolocationHandler requestPositionWithDesiredAccuracy:accuracy
                                           resultHandler:^(CLLocation *location) {
    result([LocationMapper toDictionary:location]);
  }
                                            errorHandler:^(NSString *errorCode, NSString *errorDescription){
    result([FlutterError errorWithCode: errorCode
                               message: errorDescription
                               details: nil]);
  }];
}


- (void)openSettings:(FlutterResult)result {
#if TARGET_OS_OSX
  NSString *urlString = @"x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices";
  BOOL success = [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
  result([[NSNumber alloc] initWithBool:success]);
#else
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
#endif
}
@end
