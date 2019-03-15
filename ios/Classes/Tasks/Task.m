//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "Task.h"

@implementation Task

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super init];
    if (self) {
        self.context = context;
        self.completionHandler = completionHandler;
        self.taskID = [[NSUUID alloc] init];
    }

    return self;
}

- (void)stopTask {
    if (_completionHandler != nil) {
        _completionHandler(_taskID);
    }
}

- (void)handleErrorCode:(NSString *)code message:(NSString *)message {
    _context.resultHandler([FlutterError errorWithCode:code message:message details:nil]);
}

@end