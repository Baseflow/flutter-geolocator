//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flutter/Flutter.h"
#import "TaskContext.h"
#import "TaskProtocol.h"


@interface Task : NSObject

@property NSUUID *taskID;
@property TaskContext *context;
@property CompletionHandler completionHandler;

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler;

- (void)stopTask;

- (void)handleErrorCode:(NSString *)code message:(NSString *)message;

@end