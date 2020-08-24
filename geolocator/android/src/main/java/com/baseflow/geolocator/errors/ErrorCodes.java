package com.baseflow.geolocator.errors;

public enum ErrorCodes {
    errorWhileAcquiringPosition,
    locationServicesDisabled,
    permissionDefinitionsNotFound,
    permissionDenied,
    permissionRequestInProgress;

    public String toString() {
        switch(this) {
            case errorWhileAcquiringPosition:
                return "ERROR_WHILE_ACQUIRING_POSITION";
            case locationServicesDisabled:
                return "LOCATION_SERVICES_DISABLED";
            case permissionDefinitionsNotFound:
                return "PERMISSION_DEFINITIONS_NOT_FOUND";
            case permissionDenied:
                return "PERMISSION_DENIED";
            case permissionRequestInProgress:
                return "PERMISSION_REQUEST_IN_PROGRESS";
            default:
                throw new IndexOutOfBoundsException();
        }
    }

    public String toDescription() {
        switch(this) {
            case errorWhileAcquiringPosition:
                return "An unexpected error occurred while trying to acquire the device's position.";
            case locationServicesDisabled:
                return "Location services are disabled. To receive location updates the location services should be enabled.";
            case permissionDefinitionsNotFound:
                return "No location permissions are defined in the manifest. Make sure at least ACCESS_FINE_LOCATION or ACCESS_COARSE_LOCATION are defined in the manifest.";
            case permissionDenied:
                return "User denied permissions to access the device's location.";
            case permissionRequestInProgress:
                return "Already listening for location updates. If you want to restart listening please cancel other subscriptions first";
            default:
                throw new IndexOutOfBoundsException();
        }
    }
}
