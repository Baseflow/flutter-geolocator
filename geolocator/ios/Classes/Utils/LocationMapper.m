//
//  CLLocationMapper.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/06/2020.
//

#import "LocationMapper.h"

@implementation LocationMapper
+ (NSDictionary *) toDictionary:(CLLocation *)location {
    if (location == nil) {
        return nil;
    }
    
    return @{
        @"latitude": @(location.coordinate.latitude),
        @"longitude": @(location.coordinate.longitude),
        @"timestamp": @([LocationMapper currentTimeInMilliSeconds:location.timestamp]),
        @"altitude": @(location.altitude),
        @"accuracy": @(location.horizontalAccuracy),
        @"speed": @(location.speed),
        @"speed_accuracy": @0.0,
        @"heading": @(location.course),
    };
}

+ (double)currentTimeInMilliSeconds:(NSDate *)dateToConvert {
    NSTimeInterval since1970 = [dateToConvert timeIntervalSince1970];
    return since1970 * 1000;
}
@end
