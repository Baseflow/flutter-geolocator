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
        _locationManager!.startUpdatingHeading()
    }
    
    override func stopTask() {
        if(_locationManager != nil) {
            _locationManager!.stopUpdatingLocation()
            _locationManager!.stopUpdatingHeading()
            _locationManager = nil
        }
        
        super.stopTask()
    }
}

final class CurrentLocationTask : LocationTask {
    private var lastLocation : CLLocation?
    private var lastHeading : CLHeading?
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        lastHeading = heading
        complete()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
        complete()
    }
    
    func complete(){
        if (lastLocation != nil && lastHeading != nil){
            let positionDict = lastLocation!.toDictionary(heading: lastHeading!.trueHeading)
            context.resultHandler(positionDict)
            stopTask()
        }
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
    private var lastHeading : CLHeading?
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        lastHeading = heading
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if (lastHeading != nil){
            let positionDict = location.toDictionary(heading: lastHeading!.trueHeading)
            context.resultHandler(positionDict)
        } else {
            let positionDict = location.toDictionary(heading: 0.0)
            context.resultHandler(positionDict)
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        context.resultHandler(FlutterError.init(
            code: "ERROR_UPDATING_LOCATION",
            message: error.localizedDescription,
            details: nil))
        
        stopTask()
    }
}
