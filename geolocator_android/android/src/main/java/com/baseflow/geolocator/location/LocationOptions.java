package com.baseflow.geolocator.location;

import java.util.Map;

public class LocationOptions {
  private final LocationAccuracy accuracy;
  private final long distanceFilter;
  private final long timeInterval;
  private final boolean includeNmeaMessages;
  private final boolean useMSLAltitude;

  private LocationOptions(
      LocationAccuracy accuracy,
      long distanceFilter,
      long timeInterval,
      boolean includeNmeaMessages,
      boolean useMSLAltitude) {
    this.accuracy = accuracy;
    this.distanceFilter = distanceFilter;
    this.timeInterval = timeInterval;
    this.includeNmeaMessages = includeNmeaMessages;
    this.useMSLAltitude = useMSLAltitude;
  }

  public static LocationOptions parseArguments(Map<String, Object> arguments) {
    if (arguments == null) {
      return new LocationOptions(LocationAccuracy.best, 0, 5000, false, false);
    }

    final Integer accuracy = (Integer) arguments.get("accuracy");
    final Integer distanceFilter = (Integer) arguments.get("distanceFilter");
    final Integer timeInterval = (Integer) arguments.get("timeInterval");
    Boolean includeNmeaMessages = (Boolean) arguments.get("includeNmeaMessages");
    Boolean useMSLAltitude = (Boolean) arguments.get("useMSLAltitude");

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

    if (includeNmeaMessages == null) {
      includeNmeaMessages = false;
    }
    if (useMSLAltitude == null) {
      useMSLAltitude = false;
    }

    return new LocationOptions(
        locationAccuracy,
        distanceFilter != null ? distanceFilter : 0,
        timeInterval != null ? timeInterval : 5000,
        includeNmeaMessages,
        useMSLAltitude);
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

  public boolean getIncludeNmeaMessages() {
    return includeNmeaMessages;
  }

  public boolean getUseMSLAltitude() {
    return useMSLAltitude;
  }
}
