//
//  LastKnownLocationTask.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import "LastKnownLocationTask.h"


@implementation LastKnownLocationTask

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super initWithContext:context completionHandler:completionHandler];
    if (self) {
        //
    }
    
    return self;
}

- (void)startTask {
    CLLocationManager *locationManager = [CLLocationManager new];
    CLLocation *location = [locationManager location];
    
    if (location == nil) {
        [[self context] resultHandler](nil);
        return;
    }
    
    [[self context] resultHandler]([location toDictionary]);
    [self stopTask];
}

@end
