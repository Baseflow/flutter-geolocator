#import <CoreLocation/CoreLocation.h>
#import "GeolocatorPlugin.h"
#import "Constants/ErrorCodes.h"
#import "Handlers/GeolocationHandler.h"
#import "Handlers/PermissionHandler.h"
#import "Utils/AuthorizationStatusMapper.h"
#import "Utils/LocationMapper.h"

@interface GeolocatorPlugin()
@property (strong, nonatomic) GeolocationHandler *geolocationHandler;
@property (strong, nonatomic) PermissionHandler *permissionHandler;
@end

@implementation GeolocatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter.baseflow.com/geolocator"
                                     binaryMessenger:[registrar messenger]];
    GeolocatorPlugin *instance = [[GeolocatorPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"checkPermission" isEqualToString:call.method]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        result([AuthorizationStatusMapper toDartIndex:(status)]);
    } else if ([@"isLocationServiceEnabled" isEqualToString:call.method]) {
        BOOL isEnabled = [CLLocationManager locationServicesEnabled];
        result([NSNumber numberWithBool:isEnabled]);
    } else if ([@"getLastKnownPosition" isEqualToString:call.method]) {
        [self handleGetLastKnownPosition:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleGetLastKnownPosition:(FlutterResult)result {
    
    if (![PermissionHandler hasPermissionConfiguration]) {
        [GeolocatorPlugin handleMissingPermissionConfiguration:result];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self.permissionHandler
        requestPermission:^(CLAuthorizationStatus status) {
            if (status != kCLAuthorizationStatusAuthorizedWhenInUse && status != kCLAuthorizationStatusAuthorizedAlways) {
                result([FlutterError errorWithCode: GeolocatorErrorPermissionDenied
                                           message: @"User denied permissions to access the device's location."
                                           details:nil]);
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

+ (void)handleMissingPermissionConfiguration:(FlutterResult)result {
    result([FlutterError errorWithCode: GeolocatorErrorPermissionDefinitionsNotFound
                               message: @"Permission definitions not found in the app's Info.plist. Please make sure to add either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription to the app's Info.plist file."
                               details: nil]);
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
