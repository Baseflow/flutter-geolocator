//
//  GeolocatorHandler.h
//  Pods
//
//  Created by Maurits van Beusekom on 23/06/2020.
//

#ifndef GeolocatorHandler_h
#define GeolocatorHandler_h

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef void (^GeolocatorError)(NSString *_Nonnull errorCode, NSString *_Nonnull  errorDescription);
typedef void (^GeolocatorResult)(CLLocation *_Nullable location);

@interface GeolocationHandler : NSObject

- (CLLocation *_Nullable)getLastKnownPosition;

- (void)requestPosition:(GeolocatorResult _Nonnull)resultHandler
           errorHandler:(GeolocatorError _Nonnull)errorHandler;

- (void)startListeningWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                           distanceFilter:(CLLocationDistance)distanceFilter
        pauseLocationUpdatesAutomatically:(BOOL)pauseLocationUpdatesAutomatically
                             activityType:(CLActivityType)activityType
                            resultHandler:(GeolocatorResult _Nonnull)resultHandler
                             errorHandler:(GeolocatorError _Nonnull)errorHandler;

- (void)stopListening;
@end

#endif /* GeolocatorHandler_h */
