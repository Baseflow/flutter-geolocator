//
//  LocationAccuracyParser.m
//  geolocator
//
//  Created by Maurits van Beusekom on 06/07/2020.
//

#import "LocationAccuracyMapper.h"

@implementation LocationAccuracyMapper

+(CLLocationAccuracy)toCLLocationAccuracy:(NSNumber *)value {
    if (!value) return kCLLocationAccuracyBest;
    
    switch(value.intValue) {
        case 0:
            return kCLLocationAccuracyThreeKilometers;
        case 1:
            return kCLLocationAccuracyKilometer;
        case 2:
            return kCLLocationAccuracyHundredMeters;
        case 3:
            return kCLLocationAccuracyNearestTenMeters;
        case 5:
            return kCLLocationAccuracyBestForNavigation;
        case 4:
        default:
            return kCLLocationAccuracyBest;
    }
}

@end
