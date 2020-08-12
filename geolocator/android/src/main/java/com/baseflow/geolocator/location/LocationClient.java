package com.baseflow.geolocator.location;

import com.baseflow.geolocator.errors.ErrorCallback;

interface LocationClient {
    void getLastKnownPosition(
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback);

    void startPositionUpdates(
            LocationOptions options,
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback);

    void stopPositionUpdates();
}
