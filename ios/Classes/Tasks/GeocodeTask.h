//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Task.h"
#import "TaskProtocol.h"
#import "CLPlacemark_Extensions.h"


@interface GeocodeTask : Task
@end

@interface ForwardGeocodeTask : GeocodeTask <TaskProtocol>
@end

@interface ReverseGeocodeTask : GeocodeTask <TaskProtocol>
@end
