//
//  LocationServiceHandler.m
//  geolocator
//
//  Created by Floris Smit on 10/06/2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationServiceStreamHandler.h"
#import "../Utils/ServiceStatus.h"

@interface LocationServiceStreamHandler()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationServiceStreamHandler {
  FlutterEventSink _eventSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  self.locationManager = nil;
  _eventSink = nil;
  return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
  _eventSink = events;
  if (self.locationManager == nil) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  }
  return nil;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    BOOL isEnabled = [CLLocationManager locationServicesEnabled];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (isEnabled) {
            self->_eventSink([NSNumber numberWithInt:(ServiceStatus)enabled]);
        } else {
            self->_eventSink([NSNumber numberWithInt:(ServiceStatus)disabled]);
        }
    });
  });
}

@end
