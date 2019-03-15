package com.baseflow.geolocator.data;

import com.baseflow.geolocator.utils.LocaleConverter;

import java.util.Locale;
import java.util.Map;

public class ForwardGeocodingOptions extends GeocodingOptions {
  private String mAddressToLookup;

  private ForwardGeocodingOptions(String addressToLookup, Locale locale) {
    super(locale);

    mAddressToLookup = addressToLookup;
  }

  public String getAddressToLookup() {
    return mAddressToLookup;
  }

  public static ForwardGeocodingOptions parseArguments(Object arguments) {
    @SuppressWarnings("unchecked")
    Map<String, String> argumentMap = (Map<String, String>) arguments;

    String addressToLookup = argumentMap.get("address");
    Locale locale = null;

    if (argumentMap.containsKey("localeIdentifier")) {
      locale = LocaleConverter.fromLanguageTag(argumentMap.get("localeIdentifier"));
    }

    return new ForwardGeocodingOptions(addressToLookup, locale);
  }
}
