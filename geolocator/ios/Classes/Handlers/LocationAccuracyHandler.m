//
//  LocationAccuracyHandler.m
//  geolocator
//
//  Created by Floris Smit on 11/06/2021.
//

#import <Foundation/Foundation.h>
#import "LocationAccuracyHandler.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationAccuracyHandler()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationAccuracyHandler

-(BOOL)getLocationAccuracy:(CLLocationManager*)manager {
    CLLocationManager *locationManager = self.locationManager;
    if (@available(iOS 14.0, *)) {
        switch([locationManager accuracyAuthorization]) {
            case CLAccuracyAuthorizationReducedAccuracy:
                return NO;
                break;
            case CLAccuracyAuthorizationFullAccuracy:
                return YES;
                break;
            default:
                return NO;
                break;
        }
    } else {
        return NO;
    }
}

@end
