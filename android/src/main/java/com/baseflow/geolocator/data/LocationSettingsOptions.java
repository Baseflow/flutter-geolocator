package com.baseflow.geolocator.data;

import java.util.Map;

public class LocationSettingsOptions {

    private int priority;
    private long timeInterval;
    private long fastestTimeInterval;

    public static LocationSettingsOptions parseArguments(Object arguments) {
        @SuppressWarnings("unchecked")
        Map<String, Object> map = (Map<String, Object>) arguments;

        final int priority = (int) map.get("priority");
        final long timeInterval = (int) map.get("timeInterval");
        final long fastestTimeInterval = (int) map.get("fastestTimeInterval");

        return new LocationSettingsOptions(priority, timeInterval, fastestTimeInterval);
    }

    private LocationSettingsOptions(int priority, long timeInterval, long fastestTimeInterval) {
        this.priority = priority;
        this.timeInterval = timeInterval;
        this.fastestTimeInterval = fastestTimeInterval;
    }

    public int getPriority() {
        return priority;
    }

    public long getTimeInterval() {
        return timeInterval;
    }

    public long getFastestTimeInterval() {
        return fastestTimeInterval;
    }
}