//
//  ActivityTypeMapper.m
//  geolocator_apple
//
//  Created by floris smit on 30/07/2021.
//

#import <Foundation/Foundation.h>

#import "ActivityTypeMapper.h"

@implementation ActivityTypeMapper

+ (CLActivityType)toCLActivityType:(NSNumber *)value {
    if(!value) {
        return CLActivityTypeOther;
    }
    switch(value.intValue) {
        case 0:
            return CLActivityTypeAutomotiveNavigation;
        case 1:
            return CLActivityTypeFitness;
        case 2:
            return CLActivityTypeOtherNavigation;
        case 3:
            if (@available(iOS 12.0, macOS 10.14, *)) {
                return CLActivityTypeAirborne;
            } else {
                return CLActivityTypeOther;
            }
        case 4:
            return CLActivityTypeOther;
        default:
            return CLActivityTypeOther;
    }
}

@end
