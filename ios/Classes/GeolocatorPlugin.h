//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

#import "CalculateDistanceTask.h"
#import "GeocodeTask.h"
#import "LastKnownLocationTask.h"
#import "LocationTask.h"
#import "TaskProtocol.h"
#import "Task.h"

@interface GeolocatorPlugin : NSObject <FlutterPlugin, FlutterStreamHandler, CLLocationManagerDelegate>
@end
