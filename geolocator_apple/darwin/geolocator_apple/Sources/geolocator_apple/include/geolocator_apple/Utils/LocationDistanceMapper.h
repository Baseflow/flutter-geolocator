//
//  LocationDistanceFilterMapper.h
//  Pods
//
//  Created by Maurits van Beusekom on 06/07/2020.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDistanceMapper : NSObject
+ (CLLocationDistance)toCLLocationDistance:(NSNumber *)value;
@end
