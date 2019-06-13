package com.baseflow.geolocator.data;

import static com.baseflow.geolocator.tasks.LocationUpdatesUsingLocationManagerTask.GeolocationAccuracy;

import java.util.Map;

public class LocationOptions {

  @GeolocationAccuracy
  private final int accuracy;
  private final long distanceFilter;
  private final boolean forceAndroidLocationManager;
  private final long timeInterval;
  private final long timeout;

  public static LocationOptions parseArguments(Object arguments) {
    @SuppressWarnings("unchecked")
    Map<String, Object> map = (Map<String, Object>) arguments;

    final int accuracy = (int) map.get("accuracy");
    final long distanceFilter = (int) map.get("distanceFilter");
    final boolean forceAndroidLocationManager = (boolean) map.get("forceAndroidLocationManager");
    final long timeInterval = (int) map.get("timeInterval");
    final long timeout = (int) map.get("timeout");

    return new LocationOptions(accuracy, distanceFilter, forceAndroidLocationManager, timeInterval,
        timeout);
  }


  private LocationOptions(@GeolocationAccuracy int accuracy, long distanceFilter,
      boolean forceAndroidLocationManager, long timeInterval, long timeout) {
    this.accuracy = accuracy;
    this.distanceFilter = distanceFilter;
    this.forceAndroidLocationManager = forceAndroidLocationManager;
    this.timeInterval = timeInterval;
    this.timeout = timeout;
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

  /**
   * @return The timeout for a single location request. May be {@code 0} if no timeout has been
   * set.
   */
  public long getTimeout() {
    return timeout;
  }
}
