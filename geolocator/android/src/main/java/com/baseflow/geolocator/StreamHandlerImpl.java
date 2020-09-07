package com.baseflow.geolocator;

import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.location.GeolocationManager;
import com.baseflow.geolocator.location.LocationAccuracy;
import com.baseflow.geolocator.location.LocationMapper;
import com.baseflow.geolocator.location.LocationOptions;
import com.baseflow.geolocator.permission.PermissionManager;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import java.util.Map;

class StreamHandlerImpl implements EventChannel.StreamHandler {
    private static final String TAG = "StreamHandlerImpl";

    private final GeolocationManager geolocationManager;

    @Nullable
    private EventChannel channel;

    @Nullable
    private Context context;

    @Nullable
    private Activity activity;

    public StreamHandlerImpl(GeolocationManager geolocationManager) {
        this.geolocationManager = geolocationManager;
    }

    void setActivity(@Nullable Activity activity) { this.activity = activity; }

    /**
     * Registers this instance as event stream handler on the given {@code messenger}.
     *
     * <p>Stops any previously started and unstopped calls.
     *
     * <p>This should be cleaned with {@link #stopListening} once the messenger is disposed of.
     */
    void startListening(Context context, BinaryMessenger messenger) {
        if (channel != null) {
            Log.w(TAG, "Setting a event call handler before the last was disposed.");
            stopListening();
        }

        channel = new EventChannel(messenger, "flutter.baseflow.com/geolocator_updates");
        channel.setStreamHandler(this);
        this.context = context;
    }

    /**
     * Clears this instance from listening to method calls.
     *
     * <p>Does nothing if {@link #startListening} hasn't been called, or if we're already stopped.
     */
    void stopListening() {
        if (channel == null) {
            Log.d(TAG, "Tried to stop listening when no MethodChannel had been initialized.");
            return;
        }

        channel.setStreamHandler(null);
        channel = null;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        @SuppressWarnings("unchecked")
        Map<String, Object> map = (Map<String, Object>) arguments;
        LocationOptions locationOptions = LocationOptions.parseArguments(map);

        geolocationManager.startPositionUpdates(
                context,
                activity,
                locationOptions,
                (Location location) -> events.success(LocationMapper.toHashMap(location)),
                (ErrorCodes errorCodes) -> events.error(errorCodes.toString(), errorCodes.toDescription(), null));
    }

    @Override
    public void onCancel(Object arguments) {
        geolocationManager.stopPositionUpdates();
    }
}
