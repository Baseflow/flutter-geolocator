package com.baseflow.geolocator.location;

import android.app.Activity;
import android.content.Intent;

import com.baseflow.geolocator.errors.ErrorCallback;

interface LocationClient {
    boolean isLocationServiceEnabled();

    void getLastKnownPosition(
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback);

    boolean onActivityResult(int requestCode, int resultCode);

    void startPositionUpdates(
            Activity activity,
            LocationOptions options,
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback);

    void stopPositionUpdates();
}
