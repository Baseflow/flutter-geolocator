package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.Location;

import com.baseflow.flutter.plugin.geolocator.data.CalculateDistanceOptions;
import com.baseflow.flutter.plugin.geolocator.data.Coordinate;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import java.util.Map;

class CalculateDistanceTask extends Task<CalculateDistanceOptions> {

    CalculateDistanceTask(TaskContext<CalculateDistanceOptions> context) {
        super(context);
    }

    @Override
    public void startTask() {
        Result flutterResult = getTaskContext().getResult();
        CalculateDistanceOptions options = getTaskContext().getOptions();

        if(options.getSourceCoordinates() == null || options.getDestinationCoordinates() == null) {
            flutterResult.error(
                    "ERROR_CALCULATE_DISTANCE_INVALID_PARAMS",
                    "Please supply start and end coordinates.",
                    null);
        }

        float[] results = new float[1];

        try {
            Location.distanceBetween(
                    options.getSourceCoordinates().latitude,
                    options.getSourceCoordinates().longitude,
                    options.getDestinationCoordinates().latitude,
                    options.getDestinationCoordinates().longitude,
                    results);

            // According to the Android documentation the distance is
            // always stored in the first position of the result array
            // (see: https://developer.android.com/reference/android/location/Location.html#distanceBetween(double,%20double,%20double,%20double,%20float[]))
            flutterResult.success(results[0]);
        } catch(IllegalArgumentException ex) {
            flutterResult.error(
                    "ERROR_CALCULATE_DISTANCE_ILLEGAL_ARGUMENT",
                    ex.getLocalizedMessage(),
                    null);
        } finally {
            stopTask();
        }

    }
}
