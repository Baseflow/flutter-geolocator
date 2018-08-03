import Flutter
import UIKit
import CoreLocation

public class SwiftGeolocatorPlugin: NSObject, FlutterStreamHandler, FlutterPlugin, CLLocationManagerDelegate {
    private static let METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods"
    private static let EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events"
    
    private var _streamLocationService: StreamLocationUpdatesTask?
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
        
        if call.method == "getCurrentPosition" {
            executeTask(task: CurrentLocationTask.init(
                context: buildTaskContext(arguments: call.arguments, resultHandler: result),
                completionHandler: completionAction))
        } else if call.method == "getLastKnownPosition" {
            executeTask(task: LastKnownLocationTask.init(
                context: buildTaskContext(arguments: call.arguments, resultHandler: result),
                completionHandler: completionAction))
        } else if call.method == "placemarkFromAddress" {
            executeTask(task: ForwardGeocodeTask.init(
                context: buildTaskContext(arguments: call.arguments, resultHandler: result),
                completionHandler: completionAction))
        } else if call.method == "placemarkFromCoordinates" {
            executeTask(task: ReverseGeocodeTask.init(
                context: buildTaskContext(arguments: call.arguments, resultHandler: result),
                completionHandler: completionAction))
        } else if call.method == "distanceBetween" {
            executeTask(task: CalculateDistanceTask.init(
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
        
        _streamLocationService = StreamLocationUpdatesTask.init(
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
