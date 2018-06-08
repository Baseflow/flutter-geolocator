import Flutter
import UIKit
import CoreLocation

public class SwiftFlutterGeolocatorPlugin: NSObject, FlutterStreamHandler, FlutterPlugin, CLLocationManagerDelegate {
    private static let METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods"
    private static let EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events"
    
    private var _locationManager: CLLocationManager?
    private var _result: FlutterResult?
    private var _eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let eventsChannel = FlutterEventChannel(name: EVENT_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterGeolocatorPlugin()
    
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventsChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "getPosition") {
            _result = result
            startTracking()
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        startTracking()
        
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopTracking()
        _eventSink = nil
        
        return nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let positionDict = location.toDictionary()
        
        if(_result != nil) {
            _result!(positionDict)
            _result = nil
        }
        
        if(_eventSink != nil) {
            _eventSink!(positionDict)
        }
        else {
            // Since we don't have an EventSink, we can assume nobody is listening
            // and thus we can stop tracking location updates.
            stopTracking()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if(_result != nil) {
            _result!(FlutterError.init(
                code: "ERROR_UPDATING_LOCATION",
                message: error.localizedDescription,
                details: nil))
        }
    }
    
    private func startTracking() {
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
            
            _locationManager!.desiredAccuracy = kCLLocationAccuracyBest;
        }
        
        _locationManager!.startUpdatingLocation()
    }
    
    private func stopTracking() {
        if(_locationManager != nil) {
            _locationManager!.stopUpdatingLocation()
        }
    }
}
