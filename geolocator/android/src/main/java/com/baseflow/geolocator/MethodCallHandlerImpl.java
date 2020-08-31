package com.baseflow.geolocator;

import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.errors.PermissionUndefinedException;
import com.baseflow.geolocator.location.GeolocationManager;
import com.baseflow.geolocator.location.LocationMapper;
import com.baseflow.geolocator.permission.LocationPermission;
import com.baseflow.geolocator.permission.PermissionManager;
import com.baseflow.geolocator.utils.Utils;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Translates incoming Geolocator MethodCalls into well formed Java function calls for {@link
 * Geolocator}.
 */
class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private static final String TAG = "MethodCallHandlerImpl";
    private final PermissionManager permissionManager;
    private final GeolocationManager geolocationManager;

    @Nullable
    private Context context;

    @Nullable
    private Activity activity;

    MethodCallHandlerImpl(
            PermissionManager permissionManager,
            GeolocationManager geolocationManager) {
        this.permissionManager = permissionManager;
        this.geolocationManager = geolocationManager;
    }

    @Nullable
    private MethodChannel channel;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "checkPermission":
                onCheckPermission(result);
                break;
            case "isLocationServiceEnabled":
                onIsLocationServiceEnabled(result);
                break;
            case "requestPermission":
                onRequestPermission(result);
                break;
            case "getLastKnownPosition":
                onGetLastKnownPosition(call, result);
                break;
            case "openAppSettings":
                boolean hasOpenedAppSettings = Utils.openAppSettings(this.context);
                result.success(hasOpenedAppSettings);
                break;
            case "openLocationSettings":
                boolean hasOpenedLocationSettings = Utils.openLocationSettings(this.context);
                result.success(hasOpenedLocationSettings);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    /**
     * Registers this instance as a method call handler on the given {@code messenger}.
     *
     * <p>Stops any previously started and unstopped calls.
     *
     * <p>This should be cleaned with {@link #stopListening} once the messenger is disposed of.
     */
    void startListening(Context context, BinaryMessenger messenger) {
        if (channel != null) {
            Log.wtf(TAG, "Setting a method call handler before the last was disposed.");
            stopListening();
        }

        channel = new MethodChannel(messenger, "flutter.baseflow.com/geolocator");
        channel.setMethodCallHandler(this);
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

        channel.setMethodCallHandler(null);
        channel = null;
    }

    void setActivity(@Nullable Activity activity) {
        this.activity = activity;
    }

    private void onCheckPermission(MethodChannel.Result result) {
        try {
            LocationPermission permission = this.permissionManager.checkPermissionStatus(context, activity);
            result.success(permission.toInt());
        } catch (PermissionUndefinedException e) {
            ErrorCodes errorCode = ErrorCodes.permissionDefinitionsNotFound;
            result.error(errorCode.toString(), errorCode.toDescription(), null);
        }
    }

    private void onIsLocationServiceEnabled(MethodChannel.Result result) {
        boolean isEnabled = geolocationManager.isLocationServiceEnabled(context);
        result.success(isEnabled);
    }

    private void onRequestPermission(MethodChannel.Result result) {
        try {
            this.permissionManager.requestPermission(
                    this.activity,
                    (LocationPermission permission) -> result.success(permission.toInt()) ,
                    (ErrorCodes errorCode) -> result.error(errorCode.toString(), errorCode.toDescription(), null)
            );
        } catch (PermissionUndefinedException e) {
            ErrorCodes errorCode = ErrorCodes.permissionDefinitionsNotFound;
            result.error(errorCode.toString(), errorCode.toDescription(), null);
        }
    }

    private void onGetLastKnownPosition(MethodCall call, MethodChannel.Result result) {
        boolean forceLocationManager = call.argument("forceAndroidLocationManager");

        this.geolocationManager.getLastKnownPosition(
                this.context,
                this.activity,
                forceLocationManager,
                (Location location) -> result.success(LocationMapper.toHashMap(location)),
                (ErrorCodes errorCode) -> result.error(errorCode.toString(), errorCode.toDescription(), null)
        );
    }
}
