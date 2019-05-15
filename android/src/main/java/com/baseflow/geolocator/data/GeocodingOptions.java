package com.baseflow.geolocator.data;

import java.util.Locale;

public abstract class GeocodingOptions {
    private Locale mLocale;

    GeocodingOptions(Locale locale) {
        mLocale = locale;
    }

    public Locale getLocale() {
        return mLocale;
    }
}
