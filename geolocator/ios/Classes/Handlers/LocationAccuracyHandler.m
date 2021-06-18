//
//  LocationAccuracyHandler.m
//  geolocator
//
//  Created by Floris Smit on 18/06/2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationAccuracyHandler.h"

@interface LocationAccuracyHandler()
  @property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationAccuracyHandler

- (void) getLocationAccuracyWithResult:(FlutterResult)result {
    CLLocationManager *locationManager = self.locationManager;
    if (@available(iOS 14, *)) {
        switch ([locationManager accuracyAuthorization]) {
            case CLAccuracyAuthorizationFullAccuracy:
                result([NSNumber numberWithInt:(LocationAccuracy)precise]);
                break;
            case CLAccuracyAuthorizationReducedAccuracy:
                result([NSNumber numberWithInt:(LocationAccuracy)reduced]);
                break;
            default:
                // The default location accuracy is reduced (approximate location) due to battery life choices
                result([NSNumber numberWithInt:(LocationAccuracy)precise]);
                break;
        }
    } else {
        // If the version of iOS is below version number 14, approximate location is not available, thus
        // precise location is always returned
        result([NSNumber numberWithInt:(LocationAccuracy)precise]);
    }
}

@end
