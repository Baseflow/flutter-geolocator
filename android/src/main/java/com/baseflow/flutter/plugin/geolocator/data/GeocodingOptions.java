package com.baseflow.flutter.plugin.geolocator.data;

import java.util.Locale;

public abstract class GeocodingOptions {
    private Locale mLocale;

    public GeocodingOptions(Locale locale) {
        mLocale = locale;
    }

    public Locale getLocale() {
        return mLocale;
    }
}
