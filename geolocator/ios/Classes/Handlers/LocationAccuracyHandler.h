//
//  LocationAccuracyHandler.h
//  Pods
//
//  Created by Floris Smit on 18/06/2021.
//

#ifndef LocationAccuracyHandler_h
#define LocationAccuracyHandler_h

#import <Flutter/Flutter.h>

typedef enum {
    reduced,
    precise
} LocationAccuracy;

@interface LocationAccuracyHandler : NSObject

- (void) getLocationAccuracyWithResult:(FlutterResult)result;

@end

#endif /* LocationAccuracyHandler_h */
