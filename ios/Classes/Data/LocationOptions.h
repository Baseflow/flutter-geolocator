//
//  LocationOptions.h
//  Pods
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(int, GeolocationAccuracy) {
    GeolocationAccuracyLowest = 0,
    GeolocationAccuracyLow,
    GeolocationAccuracyMedium,
    GeolocationAccuracyHigh,
    GeolocationAccuracyBest,
    GeolocationAccuracyBestForNavigation,
};

@interface LocationOptions : NSObject
@property GeolocationAccuracy accuracy;
@property CLLocationDistance distanceFilter;

- (instancetype)initWithAccuracy:(GeolocationAccuracy)accuracy distanceFilter:(CLLocationDistance)distanceFilter;

- (instancetype)initWithArguments:(id)arguments;
@end
