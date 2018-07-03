package com.baseflow.flutter.plugin.geolocator;

import com.baseflow.flutter.plugin.geolocator.services.LocationServiceInterface;
import com.baseflow.flutter.plugin.geolocator.services.OnCompletionListener;
import com.baseflow.flutter.plugin.geolocator.services.OneTimeLocationService;
import com.baseflow.flutter.plugin.geolocator.services.StreamLocationService;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;

/**
 * GeolocatorPlugin
 */
public class GeolocatorPlugin implements MethodCallHandler, EventChannel.StreamHandler, OnCompletionListener {

    private static final String METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods";
    private static final String EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events";

    private final Map<UUID, Result> mResultHandles = new HashMap<>();
    private final Registrar mRegistrar;
    private LocationServiceInterface mStreamLocationService;

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
        if (call.method.equals("getPosition")) {
            GeolocationAccuracy accuracy = parseAccuracy(call.arguments);

            UUID taskID = UUID.randomUUID();
            mResultHandles.put(UUID.randomUUID(), result);

            LocationServiceInterface locationService = new OneTimeLocationService(taskID, result, mRegistrar);
            locationService.addCompletionListener(this);
            locationService.startTracking(accuracy);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        if (mStreamLocationService != null) {
            eventSink.error(
                    "ALLREADY_LISTENING",
                    "You are already listening for location changes. Create a new instance or stop listening to the current stream.",
                    null);

            return;
        }

        GeolocationAccuracy accuracy = parseAccuracy(o);

        mStreamLocationService = new StreamLocationService(
                UUID.randomUUID(),
                eventSink,
                mRegistrar);
        mStreamLocationService.startTracking(accuracy);
    }

    @Override
    public void onCancel(Object arguments) {
        if (mStreamLocationService == null) return;

        mStreamLocationService.stopTracking();
        mStreamLocationService = null;
    }

    public void onCompletion(UUID taskID) {
        Iterator<Map.Entry<UUID, Result>> it = mResultHandles.entrySet().iterator();

        while (it.hasNext()) {
            Map.Entry<UUID, Result> entry = it.next();

            if (taskID == entry.getKey()) {
                it.remove();
            }
        }
    }

    private static GeolocationAccuracy parseAccuracy(Object o) {
        GeolocationAccuracy accuracy = GeolocationAccuracy.Medium;

        try {
            int index = (Integer) o;
            if(index > 0 && index < GeolocationAccuracy.values().length) {
                accuracy = GeolocationAccuracy.values()[index];
            }

            return accuracy;
        } catch(Exception ex) {
            return GeolocationAccuracy.Medium;
        }
    }
}
