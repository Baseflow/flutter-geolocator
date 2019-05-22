#import "GeolocatorPlugin.h"


NSString *const METHOD_CHANNEL_NAME = @"flutter.baseflow.com/geolocator/methods";
NSString *const EVENT_CHANNEL_NAME = @"flutter.baseflow.com/geolocator/events";

@implementation GeolocatorPlugin {
    StreamLocationUpdatesTask *_streamLocationService;
    NSMutableDictionary <NSUUID *, id <TaskProtocol>> *_tasks;
}

- (void)dealloc {
    NSLog(@"[GeolocatorPlugin %s]", sel_getName(_cmd));
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:METHOD_CHANNEL_NAME binaryMessenger:registrar.messenger];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:EVENT_CHANNEL_NAME binaryMessenger:registrar.messenger];
    
    GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
    
    [registrar addMethodCallDelegate:plugin channel:methodChannel];
    [eventChannel setStreamHandler:plugin];
}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    CompletionHandler completionAction = ^(NSUUID *taskID) {
        [self->_tasks removeObjectForKey:taskID];
    };
    
    if ([call.method isEqualToString:@"getCurrentPosition"]) {
        [self executeTask:[[CurrentLocationTask alloc] initWithContext:[self buildTaskContext:call.arguments resultHandler:result] completionHandler:completionAction]];
    } else if ([call.method isEqualToString:@"getLastKnownPosition"]) {
        [self executeTask:[[LastKnownLocationTask alloc] initWithContext:[self buildTaskContext:call.arguments resultHandler:result] completionHandler:completionAction]];
    } else if ([call.method isEqualToString:@"placemarkFromAddress"]) {
        [self executeTask:[[ForwardGeocodeTask alloc] initWithContext:[self buildTaskContext:call.arguments resultHandler:result] completionHandler:completionAction]];
    } else if ([call.method isEqualToString:@"placemarkFromCoordinates"]) {
        [self executeTask:[[ReverseGeocodeTask alloc] initWithContext:[self buildTaskContext:call.arguments resultHandler:result] completionHandler:completionAction]];
    } else if ([call.method isEqualToString:@"distanceBetween"]) {
        [self executeTask:[[CalculateDistanceTask alloc] initWithContext:[self buildTaskContext:call.arguments resultHandler:result] completionHandler:completionAction]];
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (void)executeTask:(id <TaskProtocol>)task {
    if (_tasks == nil) {
        _tasks = [[NSMutableDictionary <NSUUID *, id <TaskProtocol>> alloc] init];
    }
    
    _tasks[task.taskID] = task;
    [task startTask];
}

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events {
    if (_streamLocationService != nil) {
        return [FlutterError errorWithCode:@"ALLREADY_LISTENING" message:@"You are already listening for location changes. Create a new instance or stop listening to the current stream." details:nil];
    }
    
    TaskContext *context = [self buildTaskContext:arguments resultHandler:events];
    
    _streamLocationService = [[StreamLocationUpdatesTask alloc] initWithContext:context completionHandler:nil];
    [_streamLocationService startTask];
    
    return nil;
}

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
    if (_streamLocationService != nil) {
        [_streamLocationService stopTask];
        _streamLocationService = nil;
    }
    
    return nil;
}

- (TaskContext *)buildTaskContext:(id)arguments resultHandler:(ResultHandler)resultHandler {
    return [[TaskContext alloc] initWithArguments:arguments resultHandler:resultHandler];
}


@end
