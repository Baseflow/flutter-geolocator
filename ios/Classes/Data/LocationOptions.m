//
//  LocationOptions.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import "LocationOptions.h"

@implementation LocationOptions
- (instancetype)init {
    self = [super init];
    if (self) {
        self.accuracy = GeolocationAccuracyBest;
        self.distanceFilter = 0;
    }
    
    return self;
}


- (instancetype)initWithAccuracy:(GeolocationAccuracy)accuracy distanceFilter:(CLLocationDistance)distanceFilter {
    self = [super init];
    if (self) {
        self.accuracy = accuracy;
        self.distanceFilter = distanceFilter;
    }
    
    return self;
}

- (instancetype)initWithArguments:(id)arguments {
    self = [super init];
    if (self) {
        if ([arguments isKindOfClass:[NSDictionary class]]) {
            NSNumber *accuracy = arguments[@"accuracy"];
            NSNumber *distanceFilter = arguments[@"distanceFilter"];
            
            self.accuracy = (GeolocationAccuracy) accuracy.intValue;
            self.distanceFilter = distanceFilter.doubleValue;
        }
    }
    
    return self;
}

@end
