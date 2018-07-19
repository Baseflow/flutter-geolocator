package com.baseflow.flutter.plugin.geolocator;

import com.baseflow.flutter.plugin.geolocator.tasks.CalculateDistanceTask;
import com.baseflow.flutter.plugin.geolocator.tasks.ForwardGeocodingTask;
import com.baseflow.flutter.plugin.geolocator.tasks.OneTimeLocationTask;
import com.baseflow.flutter.plugin.geolocator.tasks.ReverseGeocodingTask;
import com.baseflow.flutter.plugin.geolocator.tasks.StreamLocationTask;
import com.baseflow.flutter.plugin.geolocator.tasks.Task;
import com.baseflow.flutter.plugin.geolocator.tasks.TaskContext;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.ArrayList;
import java.util.UUID;

/**
 * GeolocatorPlugin
 */
public class GeolocatorPlugin implements MethodCallHandler, EventChannel.StreamHandler, OnCompletionListener {

    private static final String METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods";
    private static final String EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events";

    private final ArrayList<Task> mTasks = new ArrayList<>();
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
        TaskContext context = TaskContext.BuildFromMethodResult(
                mRegistrar,
                result,
                call.arguments,
                this);

        if (call.method.equals("getPosition")) {
            Task task = new OneTimeLocationTask(context);
            mTasks.add(task);
            task.startTask();
        } else if (call.method.equals("toPlacemark")) {
            Task task = new ForwardGeocodingTask(context);
            mTasks.add(task);
            task.startTask();
        } else if (call.method.equals("fromPlacemark")) {
            Task task = new ReverseGeocodingTask(context);
            mTasks.add(task);
            task.startTask();
        } else if (call.method.equals("distanceBetween")) {
            Task task = new CalculateDistanceTask(context);
            mTasks.add(task);
            task.startTask();
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        if (mStreamLocationTask != null) {
            eventSink.error(
                    "ALLREADY_LISTENING",
                    "You are already listening for location changes. Create a new instance or stop listening to the current stream.",
                    null);

            return;
        }

        TaskContext context = TaskContext.BuildFromEventSink(
                mRegistrar,
                eventSink,
                o,
                this);

        mStreamLocationTask = new StreamLocationTask(
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
        Task taskToRemove = null;

        for (Task task : mTasks) {
            if(task.getTaskID() == taskID) {
                taskToRemove = task;
                break;
            }
        }

        if(taskToRemove != null) {
            mTasks.remove(taskToRemove);
        }
    }


}
