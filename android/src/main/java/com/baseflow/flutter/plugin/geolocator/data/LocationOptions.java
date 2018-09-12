package com.baseflow.flutter.plugin.geolocator.data;

import com.baseflow.flutter.plugin.geolocator.Codec;

public class LocationOptions {
    public GeolocationAccuracy accuracy = GeolocationAccuracy.BEST;
    public long distanceFilter = 0;
    public boolean forceAndroidLocationManager = false;

    public static LocationOptions parseArguments(Object arguments) {
        return Codec.decodeLocationOptions(arguments);
    }
}
