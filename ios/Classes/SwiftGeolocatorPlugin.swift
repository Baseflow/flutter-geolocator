import Flutter
import UIKit
import CoreLocation

enum GeolocationAccuracy : Int {
    case Lowest = 0, Low, Medium, High, Best
}

public class SwiftGeolocatorPlugin: NSObject, FlutterStreamHandler, FlutterPlugin, CLLocationManagerDelegate {
    private static let METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods"
    private static let EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events"
    
    private var _streamLocationService: StreamLocationTask?
    private var _tasks: [UUID:TaskProtocol] = [:];
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let eventsChannel = FlutterEventChannel(name: EVENT_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftGeolocatorPlugin()
    
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventsChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let completionAction: (UUID) -> Void = {
            (taskId) in self._tasks.removeValue(forKey: taskId)
        }
        
        if call.method == "getPosition" {
            executeTask(task: OneTimeLocationTask.init(
                context: buildTaskContext(arguments: call.arguments, resultHandler: result),
                completionHandler: completionAction))
        } else if call.method == "toPlacemark" {
            executeTask(task: ForwardGeocodeTask.init(
                context: buildTaskContext(arguments: call.arguments, resultHandler: result),
                completionHandler: completionAction))
        } else if call.method == "fromPlacemark" {
            executeTask(task: ReverseGeocodeTask.init(
                context: buildTaskContext(arguments: call.arguments, resultHandler: result),
                completionHandler: completionAction))
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func executeTask(task: TaskProtocol) {
        _tasks[task.taskID] = task
        task.startTask()
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if _streamLocationService != nil {
            return FlutterError.init(
                code: "ALLREADY_LISTENING",
                message: "You are already listening for location changes. Create a new instance or stop listening to the current stream.",
                details: nil)
        }

        let context = buildTaskContext(arguments: arguments, resultHandler: events)
        
        _streamLocationService = StreamLocationTask.init(
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
        return TaskContext.init(
            resultHandler: resultHandler,
            arguments: arguments)
    }
}
