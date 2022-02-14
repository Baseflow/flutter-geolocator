//
//  LocationDistanceMapper.m
//  geolocator
//
//  Created by Maurits van Beusekom on 06/07/2020.
//

#import "LocationDistanceMapper.h"

@implementation LocationDistanceMapper

+(CLLocationDistance)toCLLocationDistance:(NSNumber *)value {
    if (!value) return kCLDistanceFilterNone;
    
    return value > 0 ? value.doubleValue : kCLDistanceFilterNone;
}

@end
