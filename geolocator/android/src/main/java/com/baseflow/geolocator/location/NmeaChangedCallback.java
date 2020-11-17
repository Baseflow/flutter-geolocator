package com.baseflow.geolocator.location;


@FunctionalInterface
public interface NmeaChangedCallback {
    void onNmeaMessage(String message, long timeStamp);
}
