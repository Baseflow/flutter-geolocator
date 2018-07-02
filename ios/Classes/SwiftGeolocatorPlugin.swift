import Flutter
import UIKit
import CoreLocation

enum GeolocationAccuracy : Int {
    case Lowest = 0, Low, Medium, High, Best
}

public class SwiftGeolocatorPlugin: NSObject, FlutterStreamHandler, FlutterPlugin, CLLocationManagerDelegate {
    private static let METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods"
    private static let EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events"
    
    private var _streamLocationService: StreamLocationService?
    private var _oneTimeLocationServices: [String:LocationService] = [:];
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let eventsChannel = FlutterEventChannel(name: EVENT_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftGeolocatorPlugin()
    
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventsChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "getPosition") {
            if let argument = call.arguments as? Int, let accuracy = GeolocationAccuracy(rawValue: argument) {
                
                let taskId = UUID().uuidString
                let completionAction: (String) -> Void = {
                    (taskId) in self._oneTimeLocationServices.removeValue(forKey: taskId)
                }
                let oneTimeLocationService = OneTimeLocationService.init(
                    taskId: taskId,
                    resultHandler: result,
                    completionHandler: completionAction);
                
                _oneTimeLocationServices[taskId] = oneTimeLocationService
                
                let clAccuracy = determineAccuracy(accuracy: accuracy)
                oneTimeLocationService.startTracking(accuracy: clAccuracy)
            } else {
                result(FlutterError.init(
                    code: "INVALID_ARGUMENT",
                    message:"The supplied argument is invalid.",
                    details:nil))
            }
            
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if _streamLocationService != nil {
            return FlutterError.init(
                code: "ALLREADY_LISTENING",
                message: "You are already listening for location changes. Create a new instance or stop listening to the current stream.",
                details: nil)
        }
        
        if let argument = arguments as? Int, let accuracy = GeolocationAccuracy(rawValue: argument) {
            let clAccuracy = determineAccuracy(accuracy: accuracy)
            
            _streamLocationService = StreamLocationService.init(
                taskId: UUID().uuidString,
                resultHandler: events,
                completionHandler: nil);
            
            _streamLocationService?.startTracking(accuracy: clAccuracy)
        }
        
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if _streamLocationService != nil {
            _streamLocationService?.stopTracking()
            _streamLocationService = nil
        }
        
        return nil
    }

    private func determineAccuracy(accuracy: GeolocationAccuracy) -> CLLocationAccuracy {
        switch(accuracy) {
            case .Lowest: return kCLLocationAccuracyThreeKilometers
            case .Low: return kCLLocationAccuracyKilometer
            case .Medium: return kCLLocationAccuracyHundredMeters
            case .High: return kCLLocationAccuracyNearestTenMeters
            case .Best: return kCLLocationAccuracyBest
        }
    }
}
