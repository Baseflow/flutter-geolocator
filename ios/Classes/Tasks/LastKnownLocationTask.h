//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TaskProtocol.h"
#import "CLLocation_Extensions.h"
#import "Task.h"


@interface LastKnownLocationTask : Task <TaskProtocol>
@end