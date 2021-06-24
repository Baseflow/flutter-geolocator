//
//  LocationAccuracyHandler.m
//  geolocator
//
//  Created by Floris Smit on 18/06/2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationAccuracyHandler.h"
#import "ErrorCodes.h"

@implementation LocationAccuracyHandler

- (void) getLocationAccuracyWithResult:(FlutterResult)result {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if (@available(iOS 14, *)) {
        switch ([locationManager accuracyAuthorization]) {
            case CLAccuracyAuthorizationFullAccuracy:
                return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
            case CLAccuracyAuthorizationReducedAccuracy:
                return result([NSNumber numberWithInt:(LocationAccuracy)reduced]);
            default:
                // in iOS 14, reduced location accuracy is the default
                return result([NSNumber numberWithInt:(LocationAccuracy)reduced]);
        }
    } else {
        // If the version of iOS is below version number 14, approximate location is not available, thus
        // precise location is always returned
        return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
    }
}

- (void) requestTemporaryFullAccuracyWithResult:(FlutterResult)result {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if ([dictionary objectForKey:@"TemporaryPreciseAccuracy"] == nil) {
        return result([FlutterError errorWithCode:GeolocatorErrorTemporaryAccuracyDictionaryNotFound
                                          message:@"The temporary accuracy dictionary key is not set in the infop.list"
                                          details:nil]);
    }
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if (@available(iOS 14.0, *)) {
        switch ([locationManager accuracyAuthorization]) {
            case CLAccuracyAuthorizationReducedAccuracy: {
                [locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"TemporaryPreciseAccuracy"
                                                                              completion:^(NSError *error) {
                    if (error == nil) {
                        return;
                    } else {
                        // This error should never be thrown, since all the error cases are covered
                        return result([FlutterError errorWithCode:[[NSNumber numberWithInteger:error.code] stringValue]
                                                          message:error.description
                                                          details:nil]);
                    }
                }];
                return;
            }
            case CLAccuracyAuthorizationFullAccuracy:
                return result([FlutterError errorWithCode:GeolocatorErrorPreciseAccuracyEnabled
                                                  message:@"Precise Location Accuracy is already enabled"
                                                  details:nil]);
        }
    } else {
        return result([FlutterError errorWithCode:GeolocatorErrorApproximateLocationNotSupported
                                          message:@"iOS 13 and below does not support requesting temporary full accuracy"
                                          details:nil]);
    }
}

@end
