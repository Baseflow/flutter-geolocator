//
//  AuthorizationStatusMapper.h
//  Pods
//
//  Created by Maurits van Beusekom on 23/06/2020.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AuthorizationStatusMapper : NSObject
+ (NSNumber *) toDartIndex: (CLAuthorizationStatus) authorizationStatus;
@end
