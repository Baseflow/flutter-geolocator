package com.baseflow.flutter.plugin.geolocator.data;

import com.baseflow.flutter.plugin.geolocator.utils.LocaleConverter;

import java.util.Locale;
import java.util.Map;

public class ReverseGeocodingOptions extends GeocodingOptions {
    private Coordinate mCoordinate;

    public ReverseGeocodingOptions(Coordinate coordinate, Locale locale) {
        super(locale);

        mCoordinate = coordinate;
    }

    public Coordinate getCoordinate() {
         return mCoordinate;
    }

    public static ReverseGeocodingOptions parseArguments(Object arguments) {
        @SuppressWarnings("unchecked")
        Map<String, Object> argumentMap = (Map<String, Object>)arguments;

        Locale locale = null;
        Coordinate coordinate = new Coordinate(
                (double)argumentMap.get("latitude"),
                (double)argumentMap.get("longitude"));

        if (argumentMap.containsKey("localeIdentifier")) {
            locale = LocaleConverter.fromLanguageTag((String)argumentMap.get("localeIdentifier"));
        }

        return new ReverseGeocodingOptions(coordinate, locale);
    }
}
