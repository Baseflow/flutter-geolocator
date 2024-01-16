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
    
    NSMutableDictionary *locationMap = [[NSMutableDictionary alloc]initWithCapacity:13];
    
    [locationMap setObject:@(location.coordinate.latitude) forKey: @"latitude"];
    [locationMap setObject:@(location.coordinate.longitude) forKey: @"longitude"];
    [locationMap setObject:@(location.horizontalAccuracy) forKey: @"accuracy"];
    
    double timestamp = [LocationMapper currentTimeInMilliSeconds:location.timestamp];
    [locationMap setObject:@(timestamp) forKey: @"timestamp"];
    
    // A negative speed value indicates an invalid speed.
    // When the speedAccuracy contains a negative number, the value in the speed property is invalid.
    //
    // Relevant documentation:
    // - https://developer.apple.com/documentation/corelocation/cllocation/1423798-speed?language=objc
    // - https://developer.apple.com/documentation/corelocation/cllocation/3524340-speedaccuracy?language=objc
    double speed = location.speed;
    double speedAccuracy = 0.0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
    if (@available(iOS 10.0, *)) {
        speedAccuracy = location.speedAccuracy;
    }
#endif
    if (speed >= 0 && speedAccuracy >= 0) {
        [locationMap setObject:@(speed) forKey: @"speed"];
        [locationMap setObject:@(speedAccuracy) forKey: @"speed_accuracy"];
    }
    
    // When verticalAccuracy contains 0 or a negative number, the value of altitude is invalid.
    //
    // Relevant documentation:
    // - https://developer.apple.com/documentation/corelocation/cllocation/1423820-altitude?language=objc
    // - https://developer.apple.com/documentation/corelocation/cllocation/1423550-verticalaccuracy?language=objc
    double altitudeAccuracy = location.verticalAccuracy;
    if (altitudeAccuracy > 0.0) {
        [locationMap setObject:@(location.altitude) forKey: @"altitude"];
        [locationMap setObject:@(altitudeAccuracy) forKey: @"altitude_accuracy"];
    }
    
    // A negative course value indicates that the course information is invalid.
    // When courseAccuracy contains a negative number, the value in the course property is invalid.
    //
    // Relevant documentation:
    // - https://developer.apple.com/documentation/corelocation/cllocation/1423832-course?language=objc
    // - https://developer.apple.com/documentation/corelocation/cllocation/3524338-courseaccuracy?language=objc
    double heading = location.course;
    [locationMap setObject:@(heading) forKey: @"heading"];
    if (@available(iOS 13.4, macOS 10.15.4, *)) {
        double headingAccuracy = location.courseAccuracy;
        [locationMap setObject:@(headingAccuracy) forKey: @"heading_accuracy"];
    }
    
    if(@available(iOS 15.0, macOS 12.0, *)) {
        [locationMap setObject:@(location.sourceInformation.isSimulatedBySoftware) forKey: @"is_mocked"];
    }
    
    if (@available(macOS 10.15, *)) {
      if(location.floor && location.floor.level) {
        [locationMap setObject:@(location.floor.level) forKey:@"floor"];
      }
    }
    
    return locationMap;
}

+ (double)currentTimeInMilliSeconds:(NSDate *)dateToConvert {
    NSTimeInterval since1970 = [dateToConvert timeIntervalSince1970];
    return since1970 * 1000;
}
@end
