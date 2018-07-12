package com.baseflow.flutter.plugin.geolocator;

import com.baseflow.flutter.plugin.geolocator.data.LocationOptions;

import com.google.gson.Gson;

public class Codec {
    private static final Gson GSON_DECODER = new Gson();

    public static LocationOptions decodeLocationOptions(Object arguments) {
        return GSON_DECODER.fromJson((String)arguments, LocationOptions.class);
    }
}
