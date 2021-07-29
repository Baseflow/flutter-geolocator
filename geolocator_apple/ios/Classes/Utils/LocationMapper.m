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
    
    double timestamp = [LocationMapper currentTimeInMilliSeconds:location.timestamp];
    double speedAccuracy = 0.0;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
    if (@available(iOS 10.0, *)) {
        speedAccuracy = location.speedAccuracy;
    }
#endif
    
    NSMutableDictionary *locationMap = [[NSMutableDictionary alloc]initWithCapacity:9];
    [locationMap setObject:@(location.coordinate.latitude) forKey: @"latitude"];
    [locationMap setObject:@(location.coordinate.longitude) forKey: @"longitude"];
    [locationMap setObject:@(timestamp) forKey: @"timestamp"];
    [locationMap setObject:@(location.altitude) forKey: @"altitude"];
    [locationMap setObject:@(location.horizontalAccuracy) forKey: @"accuracy"];
    [locationMap setObject:@(location.speed) forKey: @"speed"];
    [locationMap setObject:@(speedAccuracy) forKey: @"speed_accuracy"];
    [locationMap setObject:@(location.course) forKey: @"heading"];
    
    if(location.floor && location.floor.level) {
        [locationMap setObject:@(location.floor.level) forKey:@"floor"];
    }
    
    return locationMap;
}

+ (double)currentTimeInMilliSeconds:(NSDate *)dateToConvert {
    NSTimeInterval since1970 = [dateToConvert timeIntervalSince1970];
    return since1970 * 1000;
}
@end
