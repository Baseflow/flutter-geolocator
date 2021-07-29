//
//  LocationServiceHandler.m
//  geolocator
//
//  Created by Floris Smit on 10/06/2021.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
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
  if ([CLLocationManager locationServicesEnabled]) {
    _eventSink([NSNumber numberWithInt:(ServiceStatus)enabled]);
  } else {
    _eventSink([NSNumber numberWithInt:(ServiceStatus)disabled]);
  }
}

@end
