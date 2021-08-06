//
//  LocationAccuracyParser.h
//  geolocator
//
//  Created by Maurits van Beusekom on 06/07/2020.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationAccuracyMapper : NSObject
+ (CLLocationAccuracy)toCLLocationAccuracy:(NSNumber *)value;
@end
