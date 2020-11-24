package com.baseflow.geolocator;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.location.GeolocationManager;
import com.baseflow.geolocator.location.NmeaMessageaClient;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import java.util.HashMap;
import java.util.Map;

class NmeaStreamImpl implements EventChannel.StreamHandler {

  private static final String TAG = "NmeaStreamImpl";

  private final GeolocationManager geolocationManager;

  @Nullable
  private EventChannel channel;
  @Nullable
  private Context context;
  @Nullable
  private Activity activity;
  @Nullable
  private NmeaMessageaClient nmeaMessageaClient;

  public NmeaStreamImpl(GeolocationManager geolocationManager) {
    this.geolocationManager = geolocationManager;
  }

  public static Map<String, Object> toMap(String n, Long l) {
    if (n == null || l == null) {
      return null;
    }

    Map<String, Object> Nmea = new HashMap<>();

    Nmea.put("timestamp", l);
    Nmea.put("message", n);

    return Nmea;
  }

  void setActivity(@Nullable Activity activity) {
    this.activity = activity;
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

    channel = new EventChannel(messenger, "flutter.baseflow.com/nmea_updates");
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

    this.nmeaMessageaClient = geolocationManager.createNmeaClient(context);

    geolocationManager.startNmeaUpdates(
        context,
        activity,
        nmeaMessageaClient,
        (String n, long l) -> events.success(toMap(n, l)),
        (ErrorCodes errorCodes) ->
            events.error(errorCodes.toString(), errorCodes.toDescription(), null));
  }

  @Override
  public void onCancel(Object arguments) {
    if (this.nmeaMessageaClient != null) {
      geolocationManager.stopNmeaUpdates(this.nmeaMessageaClient);
    }
  }

}
