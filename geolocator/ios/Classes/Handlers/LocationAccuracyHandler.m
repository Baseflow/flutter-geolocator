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

@interface LocationAccuracyHandler()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationAccuracyHandler

- (id) init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    return self;
}

- (void) getLocationAccuracyWithResult:(FlutterResult)result {
    if (@available(iOS 14, *)) {
        switch ([self.locationManager accuracyAuthorization]) {
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

- (void) requestTemporaryFullAccuracyWithResult:(FlutterResult)result purposeKey:(NSString *)purposeKey {
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationTemporaryUsageDescriptionDictionary"] == nil) {
        return result([FlutterError errorWithCode:GeolocatorErrorPermissionDefinitionsNotFound
                                          message:@"The temporary accuracy dictionary key is not set in the infop.list"
                                          details:nil]);
    }
    
    if (@available(iOS 14.0, *)) {
        [self.locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:purposeKey
                                                                           completion:^(NSError *_Nullable error) {
            if ([self.locationManager accuracyAuthorization] == CLAccuracyAuthorizationFullAccuracy) {
                return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
            } else {
                return result([NSNumber numberWithInt:(LocationAccuracy)reduced]);
            }
        }];
    } else {
        return result([NSNumber numberWithInt:(LocationAccuracy)precise]);
    }
}

@end
