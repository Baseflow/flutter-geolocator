//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "CLLocation_Extensions.h"

@interface CLPlacemark (CLPlacemark_Extensions)
- (NSDictionary *)toDictionary;
@end
