package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.Location;

import com.baseflow.flutter.plugin.geolocator.data.Coordinate;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import java.util.Map;

class CalculateDistanceTask extends Task {
    private Coordinate mStartCoordinate;
    private Coordinate mEndCoordinate;

    public CalculateDistanceTask(TaskContext context) {
        super(context);

        parseCoordinates(context.getArguments());
    }

    private void parseCoordinates(Object arguments) {
        if(arguments == null) {
            mStartCoordinate = null;
            mEndCoordinate = null;
        }

        @SuppressWarnings("unchecked")
        Map<String, Double> coordinates = (Map<String, Double>)arguments;

        if(coordinates == null)
            throw new IllegalArgumentException("No coordinates supplied to calculate distance between.");

        mStartCoordinate = new Coordinate(
                coordinates.get("startLatitude"),
                coordinates.get("startLongitude"));
        mEndCoordinate = new Coordinate(
                coordinates.get("endLatitude"),
                coordinates.get("endLongitude"));
    }

    @Override
    public void startTask() {
        Result flutterResult = getTaskContext().getResult();

        if(mStartCoordinate == null || mEndCoordinate == null) {
            flutterResult.error(
                    "ERROR_CALCULATE_DISTANCE_INVALID_PARAMS",
                    "Please supply start and end coordinates.",
                    null);
        }

        float[] results = new float[1];

        try {
            Location.distanceBetween(
                    mStartCoordinate.latitude,
                    mStartCoordinate.longitude,
                    mEndCoordinate.latitude,
                    mEndCoordinate.longitude,
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
