package com.baseflow.geolocator.location;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.EventChannel;

public class LocationServiceStatusReceiver extends BroadcastReceiver {
    @NonNull
    private final EventChannel.EventSink events;

    private boolean isEnabled = false;

    public LocationServiceStatusReceiver(@NonNull EventChannel.EventSink events) {
        this.events = events;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (LocationManager.PROVIDERS_CHANGED_ACTION.equals(intent.getAction())) {

            LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
            boolean isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
            boolean isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

            if (isGpsEnabled || isNetworkEnabled) {
                /*
                It may occur that the broadcastreceiver receives several events of the same type,
                that's why u should check whether or not the event is fired more then one time.
                This is realised by using the [isEnabled] boolean
                 */
                if (!isEnabled) {
                    isEnabled = true;
                    events.success(ServiceStatus.enabled.ordinal());
                }
            } else {
                if (isEnabled) {
                    isEnabled = false;
                    events.success(ServiceStatus.disabled.ordinal());
                }
            }
        }
    }
}
