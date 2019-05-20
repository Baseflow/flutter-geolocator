//
//  GeocodeTask.h
//  Pods
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Task.h"
#import "TaskProtocol.h"
#import "CLPlacemark_Extensions.h"


@interface GeocodeTask : Task
@end

@interface ForwardGeocodeTask : GeocodeTask <TaskProtocol>
@end

@interface ReverseGeocodeTask : GeocodeTask <TaskProtocol>
@end
