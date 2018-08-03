//
//  CalculateDistance.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 18/07/2018.
//

import Foundation
import CoreLocation

class CalculateDistanceTask : Task, TaskProtocol {
    private var _startLocation: CLLocation?
    private var _endLocation: CLLocation?
    
    required init(context: TaskContext, completionHandler: CompletionHandler?) {
        super.init(context: context,
                   completionHandler: completionHandler)
        
        parseCoordinates(arguments: context.arguments)
    }
    
    func parseCoordinates(arguments: Any?) {
        if let location = context.arguments as! NSDictionary? {
            let startLatitude = location.object(forKey: "startLatitude") as! CLLocationDegrees
            let startLongitude = location.object(forKey: "startLongitude") as! CLLocationDegrees
            let endLatitude = location.object(forKey: "endLatitude") as! CLLocationDegrees
            let endLongitude = location.object(forKey: "endLongitude") as! CLLocationDegrees
            
            _startLocation = CLLocation.init(latitude: startLatitude, longitude: startLongitude)
            _endLocation = CLLocation.init(latitude: endLatitude, longitude: endLongitude)
        } else {
            _startLocation = nil
            _endLocation = nil
        }
    }
    
    func startTask() {
        guard let startLocation = _startLocation, let endLocation = _endLocation else {
            handleError(
                code: "ERROR_CALCULATE_DISTANCE_INVALID_PARAMS",
                message: "Please supply start and end coordinates.")
            
            stopTask()
            return;
        }
        
        let distance = endLocation.distance(from: startLocation)
        
        context.resultHandler(distance)
        
        stopTask()
    }
}
