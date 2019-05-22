//
//  Task.h
//  Pods
//
//  Created by Maurits van Beusekom on 20/05/2019.
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

