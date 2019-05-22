//
//  TaskContext.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
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
