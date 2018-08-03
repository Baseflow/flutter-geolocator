package com.baseflow.flutter.plugin.geolocator;

import com.baseflow.flutter.plugin.geolocator.tasks.CalculateDistanceTask;
import com.baseflow.flutter.plugin.geolocator.tasks.ForwardGeocodingTask;
import com.baseflow.flutter.plugin.geolocator.tasks.LastKnownLocationTask;
import com.baseflow.flutter.plugin.geolocator.tasks.CurrentLocationTask;
import com.baseflow.flutter.plugin.geolocator.tasks.ReverseGeocodingTask;
import com.baseflow.flutter.plugin.geolocator.tasks.StreamLocationUpdatesTask;
import com.baseflow.flutter.plugin.geolocator.tasks.Task;
import com.baseflow.flutter.plugin.geolocator.tasks.TaskContext;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * GeolocatorPlugin
 */
public class GeolocatorPlugin implements MethodCallHandler, EventChannel.StreamHandler, OnCompletionListener {

    private static final String METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods";
    private static final String EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events";

    @SuppressWarnings("MismatchedQueryAndUpdateOfCollection") // mTasks is used to track active tasks, when tasks completes it is removed from the map
    private final Map<UUID, Task> mTasks = new HashMap<>();
    private final Registrar mRegistrar;
    private Task mStreamLocationTask;

    private GeolocatorPlugin(PluginRegistry.Registrar registrar) {
        this.mRegistrar = registrar;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        GeolocatorPlugin geolocatorPlugin = new GeolocatorPlugin(registrar);

        final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL_NAME);
        final EventChannel eventChannel = new EventChannel(registrar.messenger(), EVENT_CHANNEL_NAME);
        methodChannel.setMethodCallHandler(geolocatorPlugin);
        eventChannel.setStreamHandler(geolocatorPlugin);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        TaskContext context = TaskContext.buildFromMethodResult(
                mRegistrar,
                result,
                call.arguments,
                this);

        switch (call.method) {
            case "getLastKnownPosition": {
                Task task = new LastKnownLocationTask(context);
                mTasks.put(task.getTaskID(), task);
                task.startTask();
                break;
            }
            case "getCurrentPosition": {
                Task task = new CurrentLocationTask(context);
                mTasks.put(task.getTaskID(), task);
                task.startTask();
                break;
            }
            case "placemarkFromAddress": {
                Task task = new ForwardGeocodingTask(context);
                mTasks.put(task.getTaskID(), task);
                task.startTask();
                break;
            }
            case "placemarkFromCoordinates": {
                Task task = new ReverseGeocodingTask(context);
                mTasks.put(task.getTaskID(), task);
                task.startTask();
                break;
            }
            case "distanceBetween": {
                Task task = new CalculateDistanceTask(context);
                mTasks.put(task.getTaskID(), task);
                task.startTask();
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        if (mStreamLocationTask != null) {
            eventSink.error(
                    "ALREADY_LISTENING",
                    "You are already listening for location changes. Create a new instance or stop listening to the current stream.",
                    null);

            return;
        }

        TaskContext context = TaskContext.buildFromEventSink(
                mRegistrar,
                eventSink,
                o,
                this);

        mStreamLocationTask = new StreamLocationUpdatesTask(
                context);
        mStreamLocationTask.startTask();
    }

    @Override
    public void onCancel(Object arguments) {
        if (mStreamLocationTask == null) return;

        mStreamLocationTask.stopTask();
        mStreamLocationTask = null;
    }

    public void onCompletion(UUID taskID) {
        mTasks.remove(taskID);
    }


}
