package com.baseflow.geolocator.location;

import java.util.Map;

public class LocationOptions {
  public static final String USE_MSL_ALTITUDE_EXTRA = "geolocator_use_mslAltitude";

  private final LocationAccuracy accuracy;
  private final long distanceFilter;
  private final long timeInterval;
  private final Long maxUpdateAgeMillis;
  private final boolean useMSLAltitude;

  private LocationOptions(
      LocationAccuracy accuracy,
      long distanceFilter,
      long timeInterval,
      Long maxUpdateAgeMillis,
      boolean useMSLAltitude) {
    this.accuracy = accuracy;
    this.distanceFilter = distanceFilter;
    this.timeInterval = timeInterval;
    this.maxUpdateAgeMillis = maxUpdateAgeMillis;
    this.useMSLAltitude = useMSLAltitude;
  }

  public static LocationOptions parseArguments(Map<String, Object> arguments) {
    if (arguments == null) {
      return new LocationOptions(LocationAccuracy.best, 0, 5000, null, false);
    }

    final Integer accuracy = (Integer) arguments.get("accuracy");
    final Integer distanceFilter = (Integer) arguments.get("distanceFilter");
    final Integer timeInterval = (Integer) arguments.get("timeInterval");
    final Integer maxUpdateAge = (Integer) arguments.get("maxUpdateAge");
    final Boolean useMSLAltitude = (Boolean) arguments.get("useMSLAltitude");

    LocationAccuracy locationAccuracy = LocationAccuracy.best;

    if (accuracy != null) {
      switch (accuracy) {
        case 0:
          locationAccuracy = LocationAccuracy.lowest;
          break;
        case 1:
          locationAccuracy = LocationAccuracy.low;
          break;
        case 2:
          locationAccuracy = LocationAccuracy.medium;
          break;
        case 3:
          locationAccuracy = LocationAccuracy.high;
          break;
        case 5:
          locationAccuracy = LocationAccuracy.bestForNavigation;
          break;
        case 4:
        default:
          break;
      }
    }

    return new LocationOptions(
        locationAccuracy,
        distanceFilter != null ? distanceFilter : 0,
        timeInterval != null ? timeInterval : 5000,
        maxUpdateAge != null ? maxUpdateAge.longValue() : null,
        useMSLAltitude != null && useMSLAltitude);
  }

  public LocationAccuracy getAccuracy() {
    return accuracy;
  }

  public long getDistanceFilter() {
    return distanceFilter;
  }

  public long getTimeInterval() {
    return timeInterval;
  }

  public Long getMaxUpdateAgeMillis() {
    return maxUpdateAgeMillis;
  }

  public boolean isUseMSLAltitude() {
    return useMSLAltitude;
  }
}
