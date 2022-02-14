//
//  PermissionUtils.m
//  geolocator
//
//  Created by Maurits van Beusekom on 27/08/2021.
//

#import "PermissionUtils.h"

@implementation PermissionUtils
+ (BOOL) isStatusGranted:(CLAuthorizationStatus)authorizationStatus {
#if TARGET_OS_OSX
    if (@available(macOS 10.12, *)) {
      return (authorizationStatus == kCLAuthorizationStatusAuthorized ||
              authorizationStatus == kCLAuthorizationStatusAuthorizedAlways);
    } else {
      return authorizationStatus == kCLAuthorizationStatusAuthorized;
    }
#else
  return (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
          authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
#endif
}
@end
