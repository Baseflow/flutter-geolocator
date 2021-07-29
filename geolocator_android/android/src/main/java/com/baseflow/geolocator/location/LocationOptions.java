package com.baseflow.geolocator.location;

import java.util.Map;

public class LocationOptions {
  private LocationAccuracy accuracy;
  private long distanceFilter;
  private long timeInterval;

  public static LocationOptions parseArguments(Map<String, Object> arguments) {
    final int accuracy = (int) arguments.get("accuracy");
    final long distanceFilter = (int) arguments.get("distanceFilter");
    final long timeInterval = (int) arguments.get("timeInterval");

    LocationAccuracy locationAccuracy = LocationAccuracy.best;

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
        locationAccuracy = LocationAccuracy.best;
        break;
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
