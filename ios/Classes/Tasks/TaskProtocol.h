//
//  TaskProtocol.h
//  Pods
//
//  Created by Maurits van Beusekom on 20/05/2019.
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
