package com.baseflow.flutter.plugin.geolocator.data;

import java.util.Map;

public class CalculateDistanceOptions {
    private Coordinate mSourceCoordinates;
    private Coordinate mDestinationCoordinates;

    public CalculateDistanceOptions(Coordinate sourceCoordinates, Coordinate destinationCoordinates) {
        mSourceCoordinates = sourceCoordinates;
        mDestinationCoordinates = destinationCoordinates;
    }

    public Coordinate getSourceCoordinates() {
        return mSourceCoordinates;
    }

    public Coordinate getDestinationCoordinates() {
        return mDestinationCoordinates;
    }

    public static CalculateDistanceOptions parseArguments(Object arguments) {
        Coordinate sourceCoordinate;
        Coordinate destinationCoordinate;

        if(arguments == null) {
            throw new IllegalArgumentException("No coordinates supplied to calculate distance between.");
        }

        @SuppressWarnings("unchecked")
        Map<String, Double> coordinates = (Map<String, Double>)arguments;

        if(coordinates == null)
            throw new IllegalArgumentException("No coordinates supplied to calculate distance between.");

        sourceCoordinate = new Coordinate(
                coordinates.get("startLatitude"),
                coordinates.get("startLongitude"));
        destinationCoordinate = new Coordinate(
                coordinates.get("endLatitude"),
                coordinates.get("endLongitude"));

        return new CalculateDistanceOptions(sourceCoordinate, destinationCoordinate);
    }
}
