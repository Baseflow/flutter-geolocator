//
//  LocationTask.h
//  Pods
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Flutter/Flutter.h>

#import "CLLocation_Extensions.h"
#import "LocationOptions.h"
#import "Task.h"
#import "TaskProtocol.h"


@interface LocationTask : Task <TaskProtocol, CLLocationManagerDelegate> {
    @protected CLLocationManager * _locationManager;
}
@end

@interface CurrentLocationTask : LocationTask
@end

@interface StreamLocationUpdatesTask : LocationTask
@end
