package com.baseflow.geolocator.location;

import android.location.Location;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

/**
 * Utility class to filter inaccurate location updates that might cause GPS drift.
 * Detects and filters out positions that are physically implausible based on
 * speed, distance, and accuracy.
 */
public class LocationAccuracyFilter {
    private static final String TAG = "LocationAccuracyFilter";

    // Constants for filtering
    private static final float MAX_ACCURACY_THRESHOLD = 300.0f; // meters
    private static final float MAX_SPEED_THRESHOLD = 280.0f; // m/s (~1000 km/h to support aircraft)
    private static final float MAX_DISTANCE_JUMP = 1000.0f; // meters

    @Nullable private static Location lastFilteredLocation = null;
    private static boolean filterEnabled = false;

    /**
     * Sets whether filtering is enabled.
     * This should be called when starting location updates based on user preferences.
     *
     * @param enabled Whether filtering should be enabled
     */
    public static void setFilterEnabled(boolean enabled) {
        filterEnabled = enabled;
        // Reset the filter state when changing the setting
        if (enabled) {
            reset();
        }
    }

    /**
     * Checks if a location update should be accepted based on realistic movement patterns.
     *
     * @param newLocation The new location to evaluate
     * @return true if the location should be accepted, false if it should be filtered
     */
    public static boolean shouldAcceptLocation(@NonNull Location newLocation) {
        // If filtering is disabled, always accept locations
        if (!filterEnabled) {
            return true;
        }

        // Always accept the first position
        if (lastFilteredLocation == null) {
            lastFilteredLocation = newLocation;
            return true;
        }

        // Time difference in seconds
        float timeDelta = (newLocation.getTime() - lastFilteredLocation.getTime()) / 1000.0f;

        // Don't filter if time hasn't advanced
        if (timeDelta <= 0) {
            lastFilteredLocation = newLocation;
            return true;
        }

        // Calculate distance in meters
        float distance = newLocation.distanceTo(lastFilteredLocation);

        // Calculate speed (m/s)
        float speed = distance / timeDelta;

        // Get position accuracy (if available)
        float accuracy = newLocation.hasAccuracy() ? newLocation.getAccuracy() : 0.0f;

        // Filters to apply - use a conservative approach to avoid affecting legitimate use cases
        boolean shouldFilter = false;

        // Filter based on very poor accuracy - this catches points with extremely poor accuracy
        if (accuracy > MAX_ACCURACY_THRESHOLD) {
            Log.d(TAG, "Filtered location: Poor accuracy " + accuracy + "m");
            shouldFilter = true;
        }

        // Filter based on unrealistically high speeds 
        if (speed > MAX_SPEED_THRESHOLD) {
            Log.d(TAG, "Filtered location: Unrealistic speed " + speed + "m/s");
            shouldFilter = true;
        }

        // Filter based on large jumps when accuracy is moderate or poor
        if (distance > MAX_DISTANCE_JUMP && accuracy > 75.0f) {
            Log.d(TAG, "Filtered location: Large jump with poor accuracy - distance: " 
                + distance + "m, accuracy: " + accuracy + "m");
            shouldFilter = true;
        }

        // Accept and update reference if it passes filters
        if (!shouldFilter) {
            lastFilteredLocation = newLocation;
        }

        return !shouldFilter;
    }

    /**
     * Resets the internal state of the filter.
     * This should be called when location updates are stopped.
     */
    public static void reset() {
        lastFilteredLocation = null;
    }
} 