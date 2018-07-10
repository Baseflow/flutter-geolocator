package com.baseflow.flutter.plugin.geolocator.data;

public class Coordinates {
    private final Double mLatitude;
    private final Double mLongitude;

    public Coordinates(Double latitude, Double longitude) {
        mLatitude = latitude;
        mLongitude = longitude;
    }

    public Double getLatitude() {
        return mLatitude;
    }

    public Double getLongitude() {
        return mLongitude;
    }
}
