package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;

import com.baseflow.flutter.plugin.geolocator.OnCompletionListener;
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

        TaskContext taskContext = TaskContext.buildFromMethodResult(
                registrar,
                result,
                arguments,
                completionListener);

        return new CalculateDistanceTask(taskContext);
    }

    public static Task createCurrentLocationTask(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result result,
            Object arguments,
            OnCompletionListener completionListener) {

        TaskContext taskContext = TaskContext.buildFromMethodResult(
                registrar,
                result,
                arguments,
                completionListener);

        if (isGooglePlayServicesAvailable(registrar)) {
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

        TaskContext taskContext = TaskContext.buildFromMethodResult(
                registrar,
                result,
                arguments,
                completionListener);

        return new ForwardGeocodingTask(taskContext);
    }

    public static Task createLastKnownLocationTask(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result result,
            Object arguments,
            OnCompletionListener completionListener) {

        TaskContext taskContext = TaskContext.buildFromMethodResult(
                registrar,
                result,
                arguments,
                completionListener);

        if (isGooglePlayServicesAvailable(registrar)) {
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

        TaskContext taskContext = TaskContext.buildFromMethodResult(
                registrar,
                result,
                arguments,
                completionListener);

        return new ReverseGeocodingTask(taskContext);
    }

    public static Task createStreamLocationUpdatesTask(
            PluginRegistry.Registrar registrar,
            EventChannel.EventSink result,
            Object arguments,
            OnCompletionListener completionListener) {

        TaskContext taskContext = TaskContext.buildFromEventSink(
                registrar,
                result,
                arguments,
                completionListener);

        if (isGooglePlayServicesAvailable(registrar)) {
            return new LocationUpdatesUsingLocationServicesTask(
                    taskContext,
                    false);
        } else {
            return new LocationUpdatesUsingLocationManagerTask(
                    taskContext,
                    false);
        }
    }

    private static boolean isGooglePlayServicesAvailable(PluginRegistry.Registrar registrar) {
        Context context = registrar.activity() == null ? registrar.activity() : registrar.activeContext();

        if (context == null) {
            return false;
        }

        GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();

        return googleApiAvailability.isGooglePlayServicesAvailable(context) == ConnectionResult.SUCCESS;
    }
}
