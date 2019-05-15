package com.baseflow.geolocator.tasks;

import com.baseflow.geolocator.data.LocationOptions;

abstract class LocationUsingLocationServicesTask extends Task<LocationOptions> {
    final LocationOptions mLocationOptions;

    LocationUsingLocationServicesTask(TaskContext<LocationOptions> taskContext) {
        super(taskContext);

        mLocationOptions = taskContext.getOptions();
    }
}
