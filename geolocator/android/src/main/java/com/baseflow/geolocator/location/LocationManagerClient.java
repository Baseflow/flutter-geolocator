package com.baseflow.geolocator.location;

import android.app.Activity;
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
    public boolean onActivityResult(int requestCode, int resultCode) {
        return false;
    }

    @Override
    public void startPositionUpdates(
            Activity activity,
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
