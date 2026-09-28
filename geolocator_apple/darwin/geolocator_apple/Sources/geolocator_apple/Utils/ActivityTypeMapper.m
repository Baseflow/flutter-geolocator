//
//  ActivityTypeMapper.m
//  geolocator_apple
//
//  Created by floris smit on 30/07/2021.
//

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>

#import "../include/geolocator_apple/Utils/ActivityTypeMapper.h"

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
        case 5:
#if (TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 270000) || \
    (TARGET_OS_OSX && __MAC_OS_X_VERSION_MAX_ALLOWED >= 270000)
            if (@available(iOS 27.0, macOS 27.0, *)) {
                return CLActivityTypeMaritime;
            }
#endif
            return CLActivityTypeOtherNavigation;
        default:
            return CLActivityTypeOther;
    }
}

@end
