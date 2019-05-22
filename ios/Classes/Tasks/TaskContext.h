//
//  TaskContext.h
//  Pods
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import <Foundation/Foundation.h>


typedef void (^ResultHandler)(id result);

@interface TaskContext : NSObject

@property id arguments;
@property ResultHandler resultHandler;

- (instancetype)initWithArguments:(id)arguments resultHandler:(ResultHandler)resultHandler;

@end
