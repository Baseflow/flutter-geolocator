package com.baseflow.geolocator;

import android.content.Context;

import com.baseflow.geolocator.tasks.Task;
import com.baseflow.geolocator.tasks.TaskFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * GeolocatorPlugin
 */
public class GeolocatorPlugin implements
  MethodCallHandler,
  EventChannel.StreamHandler,
  OnCompletionListener,
  PluginRegistry.ViewDestroyListener, 
  FlutterPlugin {

  private static final String METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods";
  private static final String EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events";

  @SuppressWarnings("MismatchedQueryAndUpdateOfCollection")
  // mTasks is used to track active tasks, when tasks completes it is removed from the map
  private final Map<UUID, Task> mTasks = new HashMap<>();
  private Context mContext;
  private Task mStreamLocationTask;

  public void registerPlugin(Context context, BinaryMessenger messenger) {
    final MethodChannel methodChannel = new MethodChannel(messenger, METHOD_CHANNEL_NAME);
    final EventChannel eventChannel = new EventChannel(messenger, EVENT_CHANNEL_NAME);
    this.setContext(context);
    methodChannel.setMethodCallHandler(this);
    eventChannel.setStreamHandler(this);
  }

  public void setContext(Context context) {
    this.mContext = context;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    GeolocatorPlugin geolocatorPlugin = new GeolocatorPlugin();
    geolocatorPlugin.registerPlugin(registrar.context(), registrar.messenger());
    registrar.addViewDestroyListener(geolocatorPlugin);
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    this.registerPlugin(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    onCancel(null);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "getLastKnownPosition": {
        Task task = TaskFactory.createLastKnownLocationTask(
                mContext, result, call.arguments, this);
        mTasks.put(task.getTaskID(), task);
        task.startTask();
        break;
      }
      case "getCurrentPosition": {
        Task task = TaskFactory.createCurrentLocationTask(
                mContext, result, call.arguments, this);
        mTasks.put(task.getTaskID(), task);
        task.startTask();
        break;
      }
      case "placemarkFromAddress": {
        Task task = TaskFactory.createForwardGeocodingTask(
                mContext, result, call.arguments, this);
        mTasks.put(task.getTaskID(), task);
        task.startTask();
        break;
      }
      case "placemarkFromCoordinates": {
        Task task = TaskFactory.createReverseGeocodingTask(
                mContext, result, call.arguments, this);
        mTasks.put(task.getTaskID(), task);
        task.startTask();
        break;
      }
      case "distanceBetween": {
        Task task = TaskFactory.createCalculateDistanceTask(
                mContext, result, call.arguments, this);
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

    mStreamLocationTask = TaskFactory.createStreamLocationUpdatesTask(
            mContext, eventSink, o, this);
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

  @Override
  public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
    onCancel(null);
    return false;
  }
}
