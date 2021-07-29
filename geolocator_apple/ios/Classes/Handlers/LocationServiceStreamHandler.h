//
//  LocationServiceStreamHandler.h
//  Pods
//
//  Created by Floris Smit on 10/06/2021.
//

#ifndef LocationServiceStreamHandler_h
#define LocationServiceStreamHandler_h

#import <Flutter/Flutter.h>

@interface LocationServiceStreamHandler : NSObject<FlutterStreamHandler, CLLocationManagerDelegate>

@end

#endif /* LocationServiceStreamHandler_h */
