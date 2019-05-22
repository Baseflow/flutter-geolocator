//
//  CalculateDistanceTask.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import "CalculateDistanceTask.h"


@implementation CalculateDistanceTask {
    CLLocation *_startLocation;
    CLLocation *_endLocation;
}

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super initWithContext:context completionHandler:completionHandler];
    if (self) {
        //
        [self parseCoordinates:context.arguments];
    }
    
    return self;
}

- (void)parseCoordinates:(id)arguments {
    if ([arguments isKindOfClass:[NSDictionary class]]) {
        CLLocationDegrees startLatitude = ((NSNumber *)arguments[@"startLatitude"]).doubleValue;
        CLLocationDegrees startLongitude = ((NSNumber *)arguments[@"startLongitude"]).doubleValue;
        CLLocationDegrees endLatitude = ((NSNumber *)arguments[@"endLatitude"]).doubleValue;
        CLLocationDegrees endLongitude = ((NSNumber *)arguments[@"endLongitude"]).doubleValue;
        
        _startLocation = [[CLLocation alloc] initWithLatitude:startLatitude longitude:startLongitude];
        _endLocation = [[CLLocation alloc] initWithLatitude:endLatitude longitude:endLongitude];
    } else {
        _startLocation = nil;
        _endLocation = nil;
    }
}

- (void)startTask {
    if (_startLocation == nil || _endLocation == nil) {
        [self handleErrorCode:@"ERROR_CALCULATE_DISTANCE_INVALID_PARAMS" message:@"Please supply start and end coordinates."];
        [self stopTask];
        return;
    }
    
    CLLocationDistance distance = [_endLocation distanceFromLocation:_startLocation];
    
    [[self context] resultHandler](@(distance));
    [self stopTask];
}

@end
