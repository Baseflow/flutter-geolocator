package com.baseflow.geolocator.location;

import java.util.Map;

public class LocationOptions {
  private LocationAccuracy accuracy;
  private long distanceFilter;
  private long timeInterval;

  public static LocationOptions parseArguments(Map<String, Object> arguments) {
    final String accuracy = (String) arguments.get("accuracy");
    final long distanceFilter = (int) arguments.get("distanceFilter");
    final long timeInterval = (int) arguments.get("timeInterval");

    LocationAccuracy locationAccuracy = LocationAccuracy.best;

    if (accuracy != null) {
      switch (accuracy) {
        case "lowest":
          locationAccuracy = LocationAccuracy.lowest;
          break;
        case "low":
          locationAccuracy = LocationAccuracy.low;
          break;
        case "medium":
          locationAccuracy = LocationAccuracy.medium;
          break;
        case "high":
          locationAccuracy = LocationAccuracy.high;
          break;
        case "best":
          locationAccuracy = LocationAccuracy.best;
          break;
        case "bestForNavigation":
          locationAccuracy = LocationAccuracy.bestForNavigation;
          break;
      }
    }

    return new LocationOptions(locationAccuracy, distanceFilter, timeInterval);
  }

  private LocationOptions(LocationAccuracy accuracy, long distanceFilter, long timeInterval) {
    this.accuracy = accuracy;
    this.distanceFilter = distanceFilter;
    this.timeInterval = timeInterval;
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
}
