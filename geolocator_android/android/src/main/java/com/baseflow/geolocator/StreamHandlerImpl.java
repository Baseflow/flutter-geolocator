package com.baseflow.geolocator;

import android.content.Context;
import android.util.Log;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.errors.PermissionUndefinedException;
import com.baseflow.geolocator.location.*;
import com.baseflow.geolocator.permission.PermissionManager;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

import java.util.Map;

class StreamHandlerImpl implements EventChannel.StreamHandler {
  private static final String TAG = "StreamHandlerImpl";

  private final PermissionManager permissionManager;

  @Nullable private EventChannel channel;
  @Nullable private Context context;
  @Nullable private GeolocatorLocationService foregroundLocationService;

  public StreamHandlerImpl(PermissionManager permissionManager) {
    this.permissionManager = permissionManager;
  }

  public void setForegroundLocationService(
      @Nullable GeolocatorLocationService foregroundLocationService) {
    this.foregroundLocationService = foregroundLocationService;
  }

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

    disposeListeners();
    channel.setStreamHandler(null);
    channel = null;
  }

  @SuppressWarnings({"ConstantConditions", "unchecked"})
  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    try {
      if (!permissionManager.hasPermission(this.context)) {
        events.error(
            ErrorCodes.permissionDenied.toString(),
            ErrorCodes.permissionDenied.toDescription(),
            null);
        return;
      }
    } catch (PermissionUndefinedException e) {
      events.error(
          ErrorCodes.permissionDefinitionsNotFound.toString(),
          ErrorCodes.permissionDefinitionsNotFound.toDescription(),
          null);
      return;
    }

    if (foregroundLocationService == null) {
      Log.e(TAG, "Location background service has not started correctly");
      return;
    }

    @SuppressWarnings("unchecked")
    Map<String, Object> map = (Map<String, Object>) arguments;
    boolean forceLocationManager = false;
    if (map != null && map.get("forceLocationManager") != null) {
      forceLocationManager = (boolean) map.get("forceLocationManager");
    }
    LocationOptions locationOptions = LocationOptions.parseArguments(map);
    ForegroundNotificationOptions foregroundNotificationOptions = null;

    if (map != null) {
      foregroundNotificationOptions =
          ForegroundNotificationOptions.parseArguments(
              (Map<String, Object>) map.get("foregroundNotificationConfig"));
    }
    foregroundLocationService.startLocationService(forceLocationManager, locationOptions, events);
    if (foregroundNotificationOptions != null) {
      foregroundLocationService.enableBackgroundMode(foregroundNotificationOptions);
    }
  }

  @Override
  public void onCancel(Object arguments) {
    disposeListeners();
  }

  private void disposeListeners() {
    if (foregroundLocationService != null) {
      foregroundLocationService.stopLocationService();
      foregroundLocationService.disableBackgroundMode();
    }
  }
}
