//
//  CLPlacemark_Extensions.h
//  Pods
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "CLLocation_Extensions.h"

@interface CLPlacemark (CLPlacemark_Extensions)
- (NSDictionary *)toDictionary;
@end
