//
//  LocationServiceStreamHandler.h
//  Pods
//
//  Created by Floris Smit on 10/06/2021.
//

#ifndef LocationServiceStreamHandler_h
#define LocationServiceStreamHandler_h

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

@interface LocationServiceStreamHandler : NSObject<FlutterStreamHandler, CLLocationManagerDelegate>

@end

#endif /* LocationServiceStreamHandler_h */
