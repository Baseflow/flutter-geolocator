//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Flutter/Flutter.h>

#import "CLLocation_Extensions.h"
#import "LocationOptions.h"
#import "Task.h"
#import "TaskProtocol.h"


@interface LocationTask : Task <TaskProtocol, CLLocationManagerDelegate>
@end

@interface CurrentLocationTask : LocationTask
@end

@interface StreamLocationUpdatesTask : LocationTask
@end