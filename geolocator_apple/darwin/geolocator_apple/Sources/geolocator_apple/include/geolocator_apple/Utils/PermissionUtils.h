//
//  PermissionUtils.h
//  Pods
//
//  Created by Maurits van Beusekom on 27/08/2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PermissionUtils : NSObject
+ (BOOL) isStatusGranted: (CLAuthorizationStatus) authorizationStatus;
@end
