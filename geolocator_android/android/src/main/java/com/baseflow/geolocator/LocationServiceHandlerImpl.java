package com.baseflow.geolocator;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.LocationManager;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import com.baseflow.geolocator.location.LocationServiceStatusReceiver;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

public class LocationServiceHandlerImpl implements EventChannel.StreamHandler {

  private static final String TAG = "LocationServiceHandler";

  @Nullable private EventChannel channel;
  @Nullable private Context context;
  @Nullable private LocationServiceStatusReceiver receiver;

  void startListening(Context context, BinaryMessenger messenger) {
    if (channel != null) {
      Log.w(TAG, "Setting a event call handler before the last was disposed.");
      stopListening();
    }
    channel = new EventChannel(messenger, "flutter.baseflow.com/geolocator_service_updates_android");
    channel.setStreamHandler(this);
    this.context = context;
  }

  void stopListening() {
    if (channel == null) {
      return;
    }

    disposeListeners();
    channel.setStreamHandler(null);
    channel = null;
  }

  void setContext(@Nullable Context context) {
    this.context = context;
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    if (context == null) {
      return;
    }

    IntentFilter filter = new IntentFilter(LocationManager.PROVIDERS_CHANGED_ACTION);
    filter.addAction(Intent.ACTION_PROVIDER_CHANGED);
    receiver = new LocationServiceStatusReceiver(events);
    ContextCompat.registerReceiver(context, receiver, filter, ContextCompat.RECEIVER_EXPORTED);
  }

  @Override
  public void onCancel(Object arguments) {

    disposeListeners();
  }

  private void disposeListeners() {
    if (context != null && receiver != null) {
      context.unregisterReceiver(receiver);
    }
  }
}
