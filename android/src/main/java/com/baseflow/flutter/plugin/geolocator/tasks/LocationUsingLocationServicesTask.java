package com.baseflow.flutter.plugin.geolocator.tasks;

import com.baseflow.flutter.plugin.geolocator.data.LocationOptions;

abstract class LocationUsingLocationServicesTask extends Task<LocationOptions> {
    final LocationOptions mLocationOptions;

    LocationUsingLocationServicesTask(TaskContext<LocationOptions> taskContext) {
        super(taskContext);

        mLocationOptions = taskContext.getOptions();
    }
}
