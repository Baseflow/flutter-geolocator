//
//  GeolocatorHandler.h
//  Pods
//
//  Created by Maurits van Beusekom on 23/06/2020.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef void (^GeolocatorError)(NSString *_Nonnull errorCode, NSString *_Nonnull  errorDescription);
typedef void (^GeolocatorResult)(CLLocation *_Nonnull location);

@interface GeolocationHandler : NSObject

- (CLLocation *_Nullable)getLastKnownPosition;

@end
