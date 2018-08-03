//
//  CalculateDistance.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 18/07/2018.
//

import Foundation
import CoreLocation

class LastKnownLocationTask : Task, TaskProtocol {
    required init(context: TaskContext, completionHandler: CompletionHandler?) {
        super.init(context: context,
                   completionHandler: completionHandler)
    }
    
    func startTask() {
        let locationManager = CLLocationManager.init()
        let location = locationManager.location;
        
        guard let lastKnownPosition = location?.toDictionary() else {
            context.resultHandler(nil)
            return
        }

        context.resultHandler(lastKnownPosition)
        
        stopTask()
    }
}
