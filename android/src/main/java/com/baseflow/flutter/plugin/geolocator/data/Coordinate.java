package com.baseflow.flutter.plugin.geolocator.data;

public class Coordinate {
    private final Double mLatitude;
    private final Double mLongitude;

    public Coordinate(Double latitude, Double longitude) {
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
