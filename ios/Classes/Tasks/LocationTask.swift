//
//  LocationServices.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 30/06/2018.
//

import CoreLocation
import Flutter
import Foundation

class LocationTask : Task, TaskProtocol, CLLocationManagerDelegate {
    private var _locationOptions: LocationOptions
    private var _locationManager: CLLocationManager?
    
    required init(
        context: TaskContext,
        completionHandler: CompletionHandler?) {
        
        self._locationOptions = Codec.decodeLocationOptions(from: context.arguments)
        
        super.init(context: context,
                   completionHandler: completionHandler)
    }
    
    func startTask() {
        if(_locationManager == nil)
        {
            _locationManager = CLLocationManager()
            _locationManager!.delegate = self
        }

        _locationManager!.desiredAccuracy = _locationOptions.accuracy.clValue;
        _locationManager!.distanceFilter = _locationOptions.distanceFilter;
        _locationManager!.startUpdatingLocation()
    }
    
    override func stopTask() {
        if(_locationManager != nil) {
            _locationManager!.stopUpdatingLocation()
            _locationManager = nil
        }
        
        super.stopTask()
    }
}

final class CurrentLocationTask : LocationTask {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let positionDict = location.toDictionary()
        
        context.resultHandler(positionDict)
        stopTask()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        context.resultHandler(FlutterError.init(
            code: "ERROR_UPDATING_LOCATION",
            message: error.localizedDescription,
            details: nil))
        
        stopTask()
    }
}

final class StreamLocationUpdatesTask : LocationTask {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let positionDict = location.toDictionary()
        
        context.resultHandler(positionDict)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        context.resultHandler(FlutterError.init(
            code: "ERROR_UPDATING_LOCATION",
            message: error.localizedDescription,
            details: nil))
        
        stopTask()
    }
}
