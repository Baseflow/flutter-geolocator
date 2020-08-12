package com.baseflow.geolocator.location;

import android.content.Context;
import com.baseflow.geolocator.errors.ErrorCallback;

class LocationManagerClient implements LocationClient {
    private final Context context;

    public LocationManagerClient(Context context) {
        this.context = context;
    }

    @Override
    public void getLastKnownPosition(
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {
        // TODO: Add implementation...
    }

    @Override
    public void startPositionUpdates(
            LocationOptions options,
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {
        // TODO: Add implementation...
    }

    @Override
    public void stopPositionUpdates() {
        // TODO: Add implementation...
    }
}
