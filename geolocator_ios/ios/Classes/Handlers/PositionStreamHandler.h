//
//  PositionStreamHandler.h
//  Pods
//
//  Created by Maurits van Beusekom on 04/06/2021.
//

#ifndef PositionStreamHandler_h
#define PositionStreamHandler_h

#import <Flutter/Flutter.h>
#import "GeolocationHandler.h"
#import "PermissionHandler.h"

@interface PositionStreamHandler : NSObject<FlutterStreamHandler>

- (id) initWithGeolocationHandler: (GeolocationHandler *)geolocationHandler
                PermissionHandler: (PermissionHandler *)permissionHandler;

@end

#endif /* PositionStreamHandler_h */
