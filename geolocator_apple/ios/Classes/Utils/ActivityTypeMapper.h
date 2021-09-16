//
//  ActivityTypeMapper.h
//  Pods
//
//  Created by floris smit on 30/07/2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ActivityTypeMapper : NSObject
+ (CLActivityType)toCLActivityType:(NSNumber *)value;
@end
