package com.baseflow.geolocator.data;

import com.baseflow.geolocator.utils.LocaleConverter;

import java.util.Locale;
import java.util.Map;

public class ForwardGeocodingOptions extends GeocodingOptions {
  public static final String LOCALE_IDENTIFIER = "localeIdentifier";
  private static final String ADDRESS = "address";
  private static final String MAX_RESULTS = "maxResults";
  private static final String LOWER_LEFT_LATITUDE = "lowerLeftLatitude";
  private static final String LOWER_LEFT_LONGITUE = "lowerLeftLongitude";
  private static final String UPPER_RIGHT_LATITUDE = "upperRightLatitude";
  private static final String UPPER_RIGHT_LONGITUE = "upperRightLongitude";
  private static final int DEFAULT_MAX_RESULTS = 5;
  private String mAddressToLookup;
  private int maxResults;
  private Double lowerLeftLatitude;
  private Double lowerLeftLongitude;
  private Double upperRightLatitude;
  private Double upperRightLongitude;

  public ForwardGeocodingOptions(Locale locale, String mAddressToLookup, int maxResults) {
    super(locale);
    this.mAddressToLookup = mAddressToLookup;
    this.maxResults = maxResults;
  }

  public ForwardGeocodingOptions(Locale locale, String mAddressToLookup, int maxResults,
                                 double lowerLeftLatitude, double lowerLeftLongitude,
                                 double upperRightLatitude, double upperRightLongitude) {
    super(locale);
    this.mAddressToLookup = mAddressToLookup;
    this.maxResults = maxResults;
    this.lowerLeftLatitude = lowerLeftLatitude;
    this.lowerLeftLongitude = lowerLeftLongitude;
    this.upperRightLatitude = upperRightLatitude;
    this.upperRightLongitude = upperRightLongitude;
  }

  public static ForwardGeocodingOptions parseArguments(Object arguments) {
    @SuppressWarnings("unchecked")
    Map<String, Object> argumentMap = (Map<String, Object>) arguments;

    String addressToLookup = (String) argumentMap.get(ADDRESS);
    Locale locale = null;

    if (argumentMap.containsKey(LOCALE_IDENTIFIER)) {
      locale = LocaleConverter.fromLanguageTag((String) argumentMap.get(LOCALE_IDENTIFIER));
    }

    int maxResults;
    if (argumentMap.containsKey(MAX_RESULTS)) {
      maxResults = (int) argumentMap.get(MAX_RESULTS);
    } else {
      maxResults = DEFAULT_MAX_RESULTS;
    }

    if (argumentMap.containsKey(LOWER_LEFT_LATITUDE) && argumentMap.containsKey(LOWER_LEFT_LONGITUE)
            && argumentMap.containsKey(UPPER_RIGHT_LATITUDE) && argumentMap.containsKey(UPPER_RIGHT_LONGITUE)) {
      return new ForwardGeocodingOptions(
              locale,
              addressToLookup,
              maxResults,
              (double) argumentMap.get(LOWER_LEFT_LONGITUE),
              (double) argumentMap.get(LOWER_LEFT_LONGITUE),
              (double) argumentMap.get(UPPER_RIGHT_LATITUDE),
              (double) argumentMap.get(UPPER_RIGHT_LONGITUE)
      );
    } else {
      return new ForwardGeocodingOptions(locale, addressToLookup, maxResults);
    }
  }

  public String getAddressToLookup() {
    return mAddressToLookup;
  }

  public int getMaxResults() {
    return maxResults;
  }

  public Double getLowerLeftLatitude() {
    return lowerLeftLatitude;
  }

  public Double getLowerLeftLongitude() {
    return lowerLeftLongitude;
  }

  public Double getUpperRightLatitude() {
    return upperRightLatitude;
  }

  public Double getUpperRightLongitude() {
    return upperRightLongitude;
  }
}
