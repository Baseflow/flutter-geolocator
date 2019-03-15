//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^ResultHandler)(id result);

@interface TaskContext : NSObject

@property id arguments;
@property ResultHandler resultHandler;

- (instancetype)initWithArguments:(id)arguments resultHandler:(ResultHandler)resultHandler;

@end