package com.baseflow.geolocator.tasks;

import com.baseflow.geolocator.OnCompletionListener;
import com.baseflow.geolocator.data.CalculateDistanceOptions;
import com.baseflow.geolocator.data.ForwardGeocodingOptions;
import com.baseflow.geolocator.data.LocationOptions;
import com.baseflow.geolocator.data.ReverseGeocodingOptions;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import java.util.UUID;

public class TaskFactory {
  public static Task<CalculateDistanceOptions> createCalculateDistanceTask(
      PluginRegistry.Registrar registrar,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    CalculateDistanceOptions options = CalculateDistanceOptions.parseArguments(arguments);
    TaskContext<CalculateDistanceOptions> taskContext = TaskContext.buildForMethodResult(
        registrar,
        result,
        options,
        completionListener);

    return new CalculateDistanceTask(taskContext);
  }

  public static Task<LocationOptions> createCurrentLocationTask(
      String taskID,
      PluginRegistry.Registrar registrar,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    LocationOptions options = LocationOptions.parseArguments(arguments);
    TaskContext<LocationOptions> taskContext = TaskContext.buildForMethodResult(
        registrar,
        result,
        options,
        completionListener);

    if (!options.isForceAndroidLocationManager()) {
      return new LocationUpdatesUsingLocationServicesTask(
          UUID.fromString(taskID),
          taskContext,
          true);
    } else {
      return new LocationUpdatesUsingLocationManagerTask(
          UUID.fromString(taskID),
          taskContext,
          true);
    }
  }

  public static Task<ForwardGeocodingOptions> createForwardGeocodingTask(
      PluginRegistry.Registrar registrar,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    ForwardGeocodingOptions options = ForwardGeocodingOptions.parseArguments(arguments);
    TaskContext<ForwardGeocodingOptions> taskContext = TaskContext.buildForMethodResult(
        registrar,
        result,
        options,
        completionListener);

    return new ForwardGeocodingTask(taskContext);
  }

  public static Task<LocationOptions> createLastKnownLocationTask(
      String taskID,
      PluginRegistry.Registrar registrar,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    LocationOptions options = LocationOptions.parseArguments(arguments);
    TaskContext<LocationOptions> taskContext = TaskContext.buildForMethodResult(
        registrar,
        result,
        options,
        completionListener);

    if (!options.isForceAndroidLocationManager()) {
      return new LastKnownLocationUsingLocationServicesTask(UUID.fromString(taskID), taskContext);
    } else {
      return new LastKnownLocationUsingLocationManagerTask(UUID.fromString(taskID), taskContext);
    }
  }

  public static Task<ReverseGeocodingOptions> createReverseGeocodingTask(
      PluginRegistry.Registrar registrar,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    ReverseGeocodingOptions options = ReverseGeocodingOptions.parseArguments(arguments);
    TaskContext<ReverseGeocodingOptions> taskContext = TaskContext.buildForMethodResult(
        registrar,
        result,
        options,
        completionListener);

    return new ReverseGeocodingTask(taskContext);
  }

  public static Task<LocationOptions> createStreamLocationUpdatesTask(
      PluginRegistry.Registrar registrar,
      EventChannel.EventSink result,
      Object arguments,
      OnCompletionListener completionListener) {

    LocationOptions options = LocationOptions.parseArguments(arguments);
    TaskContext<LocationOptions> taskContext = TaskContext.buildForEventSink(
        registrar,
        result,
        options,
        completionListener);

    if (!options.isForceAndroidLocationManager()) {
      return new LocationUpdatesUsingLocationServicesTask(
          null,
          taskContext,
          false);
    } else {
      return new LocationUpdatesUsingLocationManagerTask(
          null,
          taskContext,
          false);
    }
  }
}
