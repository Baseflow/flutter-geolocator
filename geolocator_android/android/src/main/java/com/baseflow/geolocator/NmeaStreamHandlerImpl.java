package com.baseflow.geolocator;

import android.content.Context;
import android.util.Log;

import androidx.annotation.Nullable;

import com.baseflow.geolocator.location.NmeaClient;
import com.baseflow.geolocator.location.NmeaMapper;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

class NmeaStreamHandlerImpl implements EventChannel.StreamHandler {
  private static final String TAG = "FlutterGeolocator";

  @Nullable private EventChannel channel;
  @Nullable private Context context;
  @Nullable private NmeaClient nmeaClient;

  public NmeaStreamHandlerImpl() {}

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

    channel = new EventChannel(messenger, "flutter.baseflow.com/geolocator_nmea_updates_android");
    channel.setStreamHandler(this);
    this.context = context;
    this.nmeaClient = new NmeaClient(this.context);
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

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {

    if (nmeaClient == null) {
      Log.e(TAG, "NMEA Client has not started correctly");
      return;
    }

    nmeaClient.start();
    nmeaClient.setCallback((message -> events.success(NmeaMapper.toHashMap(message))));
  }

  @Override
  public void onCancel(Object arguments) {
    disposeListeners();
  }

  private void disposeListeners() {
    Log.e(TAG, "Geolocator position updates stopped");
    if (nmeaClient != null) {
      nmeaClient.setCallback(null);
      nmeaClient.stop();
    }
  }
}
