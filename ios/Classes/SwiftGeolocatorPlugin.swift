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
    private var _locationServices: [String:TaskProtocol] = [:];
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let eventsChannel = FlutterEventChannel(name: EVENT_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftGeolocatorPlugin()
    
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventsChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let context = buildTaskContext(arguments: call.arguments, resultHandler: result)
        let completionAction: (String) -> Void = {
            (taskId) in self._locationServices.removeValue(forKey: taskId)
        }
        
        if call.method == "getPosition" {
            let oneTimeLocationService = OneTimeLocationService.init(
                context: context,
                completionHandler: completionAction);
            
            _locationServices[context.taskID] = oneTimeLocationService
            oneTimeLocationService.startTask()
        } else if call.method == "getPlacemark" {
            let geocodingService = GeocodingService.init(
                context: context,
                completionHandler: completionAction)
            
            _locationServices[context.taskID] = geocodingService
            geocodingService.startTask()
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

        let context = buildTaskContext(arguments: arguments, resultHandler: events)
        
        _streamLocationService = StreamLocationService.init(
            context: context,
            completionHandler: nil);
        
        _streamLocationService?.startTask()
        
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if _streamLocationService != nil {
            _streamLocationService?.stopTask()
            _streamLocationService = nil
        }
        
        return nil
    }
    
    private func buildTaskContext(arguments: Any?, resultHandler: @escaping ResultHandler) -> TaskContext {
        let taskID = UUID().uuidString
        
        return TaskContext.init(
            taskID: taskID,
            resultHandler: resultHandler,
            arguments: arguments)
    }
}
