//
//  PermissionHandler.h
//  Pods
//
//  Created by Maurits van Beusekom on 26/06/2020.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef void (^PermissionConfirmation)(CLAuthorizationStatus status);
typedef void (^PermissionError)(NSString *errorCode, NSString *errorDiscription);

@interface PermissionHandler : NSObject

+ (BOOL) hasPermission;
- (void) requestPermission:(PermissionConfirmation)confirmationHandler
              errorHandler:(PermissionError)errorHandler;

@end
