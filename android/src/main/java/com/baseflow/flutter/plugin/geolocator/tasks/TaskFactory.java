package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;
import android.location.LocationProvider;

import com.baseflow.flutter.plugin.geolocator.OnCompletionListener;
import com.baseflow.flutter.plugin.geolocator.data.CalculateDistanceOptions;
import com.baseflow.flutter.plugin.geolocator.data.ForwardGeocodingOptions;
import com.baseflow.flutter.plugin.geolocator.data.LocationOptions;
import com.baseflow.flutter.plugin.geolocator.data.ReverseGeocodingOptions;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class TaskFactory {
    public static Task createCalculateDistanceTask(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result result,
            Object arguments,
            OnCompletionListener completionListener) {

        CalculateDistanceOptions options = CalculateDistanceOptions.parseArguments(arguments);
        TaskContext taskContext = TaskContext.buildForMethodResult(
                registrar,
                result,
                options,
                completionListener);

        return new CalculateDistanceTask(taskContext);
    }

    public static Task createCurrentLocationTask(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result result,
            Object arguments,
            OnCompletionListener completionListener) {

        LocationOptions options = LocationOptions.parseArguments(arguments);
        TaskContext taskContext = TaskContext.buildForMethodResult(
                registrar,
                result,
                options,
                completionListener);

        if (!options.forceAndroidLocationManager && isGooglePlayServicesAvailable(registrar)) {
            return new LocationUpdatesUsingLocationServicesTask(
                    taskContext,
                    true);
        } else {
            return new LocationUpdatesUsingLocationManagerTask(
                    taskContext,
                    true);
        }
    }

    public static Task createForwardGeocodingTask(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result result,
            Object arguments,
            OnCompletionListener completionListener) {

        ForwardGeocodingOptions options = ForwardGeocodingOptions.parseArguments(arguments);
        TaskContext taskContext = TaskContext.buildForMethodResult(
                registrar,
                result,
                options,
                completionListener);

        return new ForwardGeocodingTask(taskContext);
    }

    public static Task createLastKnownLocationTask(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result result,
            Object arguments,
            OnCompletionListener completionListener) {

        LocationOptions options = LocationOptions.parseArguments(arguments);
        TaskContext taskContext = TaskContext.buildForMethodResult(
                registrar,
                result,
                options,
                completionListener);

        if (!options.forceAndroidLocationManager && isGooglePlayServicesAvailable(registrar)) {
            return new LastKnownLocationUsingLocationServicesTask(taskContext);
        } else {
            return new LastKnownLocationUsingLocationManagerTask(taskContext);
        }
    }

    public static Task createReverseGeocodingTask(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result result,
            Object arguments,
            OnCompletionListener completionListener) {

        ReverseGeocodingOptions options = ReverseGeocodingOptions.parseArguments(arguments);
        TaskContext taskContext = TaskContext.buildForMethodResult(
                registrar,
                result,
                options,
                completionListener);

        return new ReverseGeocodingTask(taskContext);
    }

    public static Task createStreamLocationUpdatesTask(
            PluginRegistry.Registrar registrar,
            EventChannel.EventSink result,
            Object arguments,
            OnCompletionListener completionListener) {

        LocationOptions options = LocationOptions.parseArguments(arguments);
        TaskContext taskContext = TaskContext.buildForEventSink(
                registrar,
                result,
                options,
                completionListener);

        if (!options.forceAndroidLocationManager && isGooglePlayServicesAvailable(registrar)) {
            return new LocationUpdatesUsingLocationServicesTask(
                    taskContext,
                    false);
        } else {
            return new LocationUpdatesUsingLocationManagerTask(
                    taskContext,
                    false);
        }
    }

    public static Task createCheckPlayServicesAvailabilityTask(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result result,
            OnCompletionListener completionListener) {

        TaskContext taskContext = TaskContext.buildForMethodResult(
                registrar,
                result,
                null,
                completionListener);

        return new CheckPlayServicesAvailabilityTask(taskContext);
    }

    private static boolean isGooglePlayServicesAvailable(PluginRegistry.Registrar registrar) {
        Context context = registrar.activity() != null ? registrar.activity() : registrar.activeContext();

        if (context == null) {
            return false;
        }

        GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();

        return googleApiAvailability.isGooglePlayServicesAvailable(context) == ConnectionResult.SUCCESS;
    }
}
