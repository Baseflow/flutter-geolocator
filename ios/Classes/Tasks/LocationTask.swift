//
//  LocationServices.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 30/06/2018.
//

import CoreLocation
import Flutter
import Foundation

class LocationTask : NSObject, TaskProtocol, CLLocationManagerDelegate {
    private var _locationOptions: LocationOptions
    private var _locationManager: CLLocationManager?
    
    required init(
        context: TaskContext,
        completionHandler: CompletionHandler?) {
        
        self.taskID = UUID.init()
        self.context = context
        self.completionHandler = completionHandler
        self._locationOptions = Codec.decodeLocationOptions(from: context.arguments)
        
        super.init()
    }
    
    let taskID: UUID
    let context: TaskContext
    let completionHandler: CompletionHandler?
    
    func startTask() {
        if(_locationManager == nil)
        {
            _locationManager = CLLocationManager()
            _locationManager!.delegate = self
            
            if (CLLocationManager.authorizationStatus() == .notDetermined) {
                if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
                    _locationManager!.requestWhenInUseAuthorization()
                }
                else if (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil) {
                    _locationManager!.requestAlwaysAuthorization();
                }
                else {
                    NSException(name: NSExceptionName.internalInconsistencyException, reason:"To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file", userInfo: nil).raise()
                }
                
            }
            
            _locationManager!.desiredAccuracy = _locationOptions.accuracy.clValue;
            _locationManager!.distanceFilter = _locationOptions.distanceFilter;
        }
        
        _locationManager!.startUpdatingLocation()
    }
    
    func stopTask() {
        if(_locationManager != nil) {
            _locationManager!.stopUpdatingLocation()
        }
        
        guard let action = completionHandler else { return }
        action(taskID)
    }
}

final class OneTimeLocationTask : LocationTask {
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

final class StreamLocationTask : LocationTask {
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
