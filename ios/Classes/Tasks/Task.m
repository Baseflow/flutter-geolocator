//
//  Task.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
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
