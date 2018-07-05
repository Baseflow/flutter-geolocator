//
//  LocationServices.swift
//  geolocator
//
//  Created by Maurits van Beusekom on 30/06/2018.
//

import CoreLocation
import Flutter
import Foundation

class LocationService : NSObject, TaskProtocol, CLLocationManagerDelegate {
    private var _desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    private var _locationManager: CLLocationManager?
    
    required init(
        context: TaskContext,
        completionHandler: CompletionHandler?) {
        
        self.context = context
        self.completionHandler = completionHandler
        
        super.init()
        
        _desiredAccuracy = parseAccuracy(accuracy: context.arguments)
    }
    
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
            
            _locationManager!.desiredAccuracy = _desiredAccuracy;
        }
        
        _locationManager!.startUpdatingLocation()
    }
    
    func stopTask() {
        if(_locationManager != nil) {
            _locationManager!.stopUpdatingLocation()
        }
        
        guard let action = completionHandler else { return }
        action(context.taskID)
    }
    
    private func parseAccuracy(accuracy: Any?) -> CLLocationAccuracy {
        if let argument = accuracy as? Int, let accuracy = GeolocationAccuracy(rawValue: argument) {
            switch(accuracy) {
                case .Lowest: return kCLLocationAccuracyThreeKilometers
                case .Low: return kCLLocationAccuracyKilometer
                case .Medium: return kCLLocationAccuracyHundredMeters
                case .High: return kCLLocationAccuracyNearestTenMeters
                case .Best: return kCLLocationAccuracyBest
            }
        } else {
            return kCLLocationAccuracyBest
        }
    }
}

final class OneTimeLocationService : LocationService {
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

final class StreamLocationService : LocationService {
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
