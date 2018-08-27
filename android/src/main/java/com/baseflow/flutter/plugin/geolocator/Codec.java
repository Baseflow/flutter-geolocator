package com.baseflow.flutter.plugin.geolocator;

import com.baseflow.flutter.plugin.geolocator.data.LocationOptions;

import com.baseflow.flutter.plugin.geolocator.data.PlayServicesAvailability;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class Codec {
    private static final Gson GSON_DECODER =
            new GsonBuilder().enableComplexMapKeySerialization().create();


    public static LocationOptions decodeLocationOptions(Object arguments) {
        return GSON_DECODER.fromJson((String)arguments, LocationOptions.class);
    }

    public static String encodePlayServicesAvailability(PlayServicesAvailability availability) {
        return GSON_DECODER.toJson(availability);
    }
}
