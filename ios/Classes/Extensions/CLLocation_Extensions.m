//
//  CLLocation_Extensions.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import "CLLocation_Extensions.h"

@implementation CLLocation (CLLocation_Extension)
- (NSDictionary *)toDictionary {
    return @{
             @"latitude": @(self.coordinate.latitude),
             @"longitude": @(self.coordinate.longitude),
             @"timestamp": @([CLLocation currentTimeInMilliSeconds:self.timestamp]),
             @"altitude": @(self.altitude),
             @"accuracy": @(self.horizontalAccuracy),
             @"speed": @(self.speed),
             @"speed_accuracy": @0.0,
             @"heading": @(self.course),
             };
}

+ (double)currentTimeInMilliSeconds:(NSDate *)dateToConvert {
    NSTimeInterval since1970 = [dateToConvert timeIntervalSince1970];
    return since1970 * 1000;
}
@end
