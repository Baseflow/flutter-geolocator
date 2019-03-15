//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "TaskContext.h"


@implementation TaskContext
- (instancetype)initWithArguments:(id)arguments resultHandler:(ResultHandler)resultHandler {
    self = [super init];
    if (self) {
        self.arguments = arguments;
        self.resultHandler = resultHandler;
    }

    return self;
}

@end