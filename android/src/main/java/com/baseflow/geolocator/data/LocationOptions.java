package com.baseflow.geolocator.data;

import static com.baseflow.geolocator.tasks.LocationUpdatesUsingLocationManagerTask.GeolocationAccuracy;

import java.util.Map;

public class LocationOptions {

  @GeolocationAccuracy
  private final int accuracy;
  private final long distanceFilter;
  private final boolean forceAndroidLocationManager;
  private final long timeInterval;

  public static LocationOptions parseArguments(Object arguments) {
    @SuppressWarnings("unchecked")
    Map<String, Object> map = (Map<String, Object>) arguments;

    final int accuracy = (int) map.get("accuracy");
    final long distanceFilter = (int) map.get("distanceFilter");
    final boolean forceAndroidLocationManager = (boolean) map.get("forceAndroidLocationManager");
    final long timeInterval = (int) map.get("timeInterval");

    return new LocationOptions(accuracy, distanceFilter, forceAndroidLocationManager, timeInterval);
  }


  private LocationOptions(@GeolocationAccuracy int accuracy, long distanceFilter,
      boolean forceAndroidLocationManager, long timeInterval) {
    this.accuracy = accuracy;
    this.distanceFilter = distanceFilter;
    this.forceAndroidLocationManager = forceAndroidLocationManager;
    this.timeInterval = timeInterval;
  }

  @GeolocationAccuracy
  public int getAccuracy() {
    return accuracy;
  }

  public long getDistanceFilter() {
    return distanceFilter;
  }

  public boolean isForceAndroidLocationManager() {
    return forceAndroidLocationManager;
  }

  public long getTimeInterval() {
    return timeInterval;
  }
}
