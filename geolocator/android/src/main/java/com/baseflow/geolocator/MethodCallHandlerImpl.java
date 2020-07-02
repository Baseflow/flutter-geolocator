package com.baseflow.geolocator;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.errors.PermissionUndefinedException;
import com.baseflow.geolocator.permission.LocationPermission;
import com.baseflow.geolocator.permission.PermissionManager;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Translates incoming Geolocator MethodCalls into well formed Java function calls for {@link
 * Geolocator}.
 */
class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private static final String TAG = "MethodCallHandlerImpl";
    private final Geolocator geolocator;
    private final PermissionManager permissionManager;

    @Nullable
    private Context context;

    @Nullable
    private Activity activity;

    @Nullable
    private PermissionManager.ActivityRegistry activityRegistry;

    @Nullable
    private PermissionManager.PermissionRegistry permissionRegistry;


    MethodCallHandlerImpl() {
        this.geolocator = new Geolocator();
        this.permissionManager = new PermissionManager();
    }

    @Nullable
    private MethodChannel channel;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "checkPermission":
                onCheckPermission(call, result);
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

    void startListeningToActivity(
            Activity activity,
            PermissionManager.ActivityRegistry activityRegistry,
            PermissionManager.PermissionRegistry permissionRegistry) {
        this.activity = activity;
        this.activityRegistry = activityRegistry;
        this.permissionRegistry = permissionRegistry;
    }

    void stopListeningToActivity() {
        activity = null;
        activityRegistry = null;
        permissionRegistry = null;
    }

    private void onCheckPermission(MethodCall call, MethodChannel.Result result) {
        try {
            LocationPermission permission = permissionManager.checkPermissionStatus(context, activity);
            result.success(permission.toInt());
        } catch (PermissionUndefinedException e) {
            result.error(ErrorCodes.GeolocatorErrorPermissionDefinitionsNotFound,
                    "No location permissions are defined in the manifest. Make sure at least ACCESS_FINE_LOCATION or ACCESS_COARSE_LOCATION are defined in the manifest",
                    null);
        }
    }
}
