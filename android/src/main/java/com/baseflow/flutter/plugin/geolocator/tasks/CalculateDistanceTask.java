package com.baseflow.flutter.plugin.geolocator.tasks;

import android.app.Activity;
import android.location.Location;

import com.baseflow.flutter.plugin.geolocator.data.Coordinate;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import java.util.Map;

public final class CalculateDistanceTask extends Task {
    private final Activity mActivity;
    private Coordinate mStartCoordinate;
    private Coordinate mEndCoordinate;

    public CalculateDistanceTask(TaskContext context) {
        super(context);
        mActivity = context.getRegistrar().activity();

        parseCoordinates(context.getArguments());
    }

    private void parseCoordinates(Object arguments) {
        if(arguments == null) {
            mStartCoordinate = null;
            mEndCoordinate = null;
        }

        try {
            Map<String, Double> coordinates = (Map<String, Double>)arguments;

            mStartCoordinate = new Coordinate(
                    coordinates.get("startLatitude"),
                    coordinates.get("startLongitude"));
            mEndCoordinate = new Coordinate(
                    coordinates.get("endLatitude"),
                    coordinates.get("endLongitude"));

        } catch(Exception ex) {
            mStartCoordinate = null;
            mEndCoordinate = null;
        }
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
                    mStartCoordinate.getLatitude(),
                    mStartCoordinate.getLongitude(),
                    mEndCoordinate.getLatitude(),
                    mEndCoordinate.getLongitude(),
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
