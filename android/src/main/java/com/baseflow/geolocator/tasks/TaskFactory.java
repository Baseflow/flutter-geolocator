package com.baseflow.geolocator.tasks;

import android.content.Context;

import com.baseflow.geolocator.OnCompletionListener;
import com.baseflow.geolocator.data.CalculateDistanceOptions;
import com.baseflow.geolocator.data.ForwardGeocodingOptions;
import com.baseflow.geolocator.data.LocationOptions;
import com.baseflow.geolocator.data.ReverseGeocodingOptions;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class TaskFactory {
  public static Task<CalculateDistanceOptions> createCalculateDistanceTask(
      Context context,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    CalculateDistanceOptions options = CalculateDistanceOptions.parseArguments(arguments);
    TaskContext<CalculateDistanceOptions> taskContext = TaskContext.buildForMethodResult(
        context,
        result,
        options,
        completionListener);

    return new CalculateDistanceTask(taskContext);
  }

  public static Task<LocationOptions> createCurrentLocationTask(
      Context context,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    LocationOptions options = LocationOptions.parseArguments(arguments);
    TaskContext<LocationOptions> taskContext = TaskContext.buildForMethodResult(
        context,
        result,
        options,
        completionListener);

    if (!options.isForceAndroidLocationManager()) {
      return new LocationUpdatesUsingLocationServicesTask(
          taskContext,
          true);
    } else {
      return new LocationUpdatesUsingLocationManagerTask(
          taskContext,
          true);
    }
  }

  public static Task<ForwardGeocodingOptions> createForwardGeocodingTask(
      Context context,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    ForwardGeocodingOptions options = ForwardGeocodingOptions.parseArguments(arguments);
    TaskContext<ForwardGeocodingOptions> taskContext = TaskContext.buildForMethodResult(
        context,
        result,
        options,
        completionListener);

    return new ForwardGeocodingTask(taskContext);
  }

  public static Task<LocationOptions> createLastKnownLocationTask(
      Context context,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    LocationOptions options = LocationOptions.parseArguments(arguments);
    TaskContext<LocationOptions> taskContext = TaskContext.buildForMethodResult(
        context,
        result,
        options,
        completionListener);

    if (!options.isForceAndroidLocationManager()) {
      return new LastKnownLocationUsingLocationServicesTask(taskContext);
    } else {
      return new LastKnownLocationUsingLocationManagerTask(taskContext);
    }
  }

  public static Task<ReverseGeocodingOptions> createReverseGeocodingTask(
      Context context,
      MethodChannel.Result result,
      Object arguments,
      OnCompletionListener completionListener) {

    ReverseGeocodingOptions options = ReverseGeocodingOptions.parseArguments(arguments);
    TaskContext<ReverseGeocodingOptions> taskContext = TaskContext.buildForMethodResult(
        context,
        result,
        options,
        completionListener);

    return new ReverseGeocodingTask(taskContext);
  }

  public static Task<LocationOptions> createStreamLocationUpdatesTask(
      Context context,
      EventChannel.EventSink result,
      Object arguments,
      OnCompletionListener completionListener) {

    LocationOptions options = LocationOptions.parseArguments(arguments);
    TaskContext<LocationOptions> taskContext = TaskContext.buildForEventSink(
        context,
        result,
        options,
        completionListener);

    if (!options.isForceAndroidLocationManager()) {
      return new LocationUpdatesUsingLocationServicesTask(
          taskContext,
          false);
    } else {
      return new LocationUpdatesUsingLocationManagerTask(
          taskContext,
          false);
    }
  }
}
