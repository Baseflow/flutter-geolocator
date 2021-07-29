//
//  LocationMapper.h
//  Pods
//
//  Created by Maurits van Beusekom on 23/06/2020.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationMapper : NSObject
+ (NSDictionary *) toDictionary: (CLLocation *)location;
@end

