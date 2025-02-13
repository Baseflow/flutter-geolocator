package com.baseflow.geolocator.location;

import androidx.annotation.Nullable;

import java.util.Map;

public class LocationOptions {
  public static final String USE_MSL_ALTITUDE_EXTRA = "geolocator_use_mslAltitude";

  private final LocationAccuracy accuracy;
  private final long distanceFilter;
  private final long timeInterval;
  private final boolean useMSLAltitude;
  private final String forceProvider;

  private LocationOptions(
      LocationAccuracy accuracy, long distanceFilter, long timeInterval, boolean useMSLAltitude, String provider) {
    this.accuracy = accuracy;
    this.distanceFilter = distanceFilter;
    this.timeInterval = timeInterval;
    this.useMSLAltitude = useMSLAltitude;
    this.forceProvider = provider;
  }

  public static LocationOptions parseArguments(Map<String, Object> arguments) {
    if (arguments == null) {
      return new LocationOptions(LocationAccuracy.best, 0, 5000, false, null);
    }

    final Integer accuracy = (Integer) arguments.get("accuracy");
    final Integer distanceFilter = (Integer) arguments.get("distanceFilter");
    final Integer timeInterval = (Integer) arguments.get("timeInterval");
    final Boolean useMSLAltitude = (Boolean) arguments.get("useMSLAltitude");
    final String provider = (String) arguments.get("forceProvider");

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
            useMSLAltitude != null && useMSLAltitude,
            provider);
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

  public boolean isUseMSLAltitude() {
    return useMSLAltitude;
  }

  @Nullable
  public String getForceProvider() {
    return forceProvider;
  }
}
