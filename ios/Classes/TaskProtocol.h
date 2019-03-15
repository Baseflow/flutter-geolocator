//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskContext.h"

typedef void (^CompletionHandler)(NSUUID *taskID);

@protocol TaskProtocol <NSObject>

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler;

- (NSUUID *)taskID;

- (TaskContext *)context;

- (CompletionHandler *)completionHandler;

- (void)startTask;

- (void)stopTask;

@end