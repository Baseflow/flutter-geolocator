package com.baseflow.flutter.plugin.geolocator.services;

import com.baseflow.flutter.plugin.geolocator.GeolocationAccuracy;

public interface LocationServiceInterface {
    void addCompletionListener(OnCompletionListener completionListener);
    void startTracking(GeolocationAccuracy accuracy);
    void stopTracking();
}
