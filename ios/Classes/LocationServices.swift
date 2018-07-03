//
//  LocationServices.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 30/06/2018.
//

import CoreLocation
import Flutter
import Foundation

protocol LocationServiceProtocol : CLLocationManagerDelegate {
    func startTracking(accuracy: CLLocationAccuracy) -> Void
    func stopTracking() -> Void
}

class LocationService : NSObject, LocationServiceProtocol {
    typealias ResultHandler = (_ result: Any) -> ()
    typealias CompletionHandler = (_ taskId: String) -> ()
    
    private let _taskId: String
    private var _locationManager: CLLocationManager?
    private var _completionHandler: CompletionHandler? = nil
    
    let _resultHandler: ResultHandler
    
    init(taskId: String,
         resultHandler: @escaping ResultHandler,
         completionHandler: ((String) -> ())?) {
        _taskId = taskId
        _completionHandler = completionHandler
        _resultHandler = resultHandler
    }
    
    public func startTracking(accuracy: CLLocationAccuracy) {
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
            
            _locationManager!.desiredAccuracy = accuracy;
        }
        
        _locationManager!.startUpdatingLocation()
    }
    
    public func stopTracking() {
        if(_locationManager != nil) {
            _locationManager!.stopUpdatingLocation()
        }
        
        guard let action = _completionHandler else { return }
        action(_taskId)
    }
}

final class OneTimeLocationService : LocationService {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let positionDict = location.toDictionary()
        
        _resultHandler(positionDict)
        stopTracking()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _resultHandler(FlutterError.init(
            code: "ERROR_UPDATING_LOCATION",
            message: error.localizedDescription,
            details: nil))
        
        stopTracking()
    }
}

final class StreamLocationService : LocationService {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let positionDict = location.toDictionary()
        
        _resultHandler(positionDict)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _resultHandler(FlutterError.init(
            code: "ERROR_UPDATING_LOCATION",
            message: error.localizedDescription,
            details: nil))
        
        stopTracking()
    }
}
