package com.baseflow.geolocator.tasks;

import androidx.annotation.Nullable;
import com.baseflow.geolocator.data.LocationOptions;
import java.util.UUID;

abstract class LocationUsingLocationServicesTask extends Task<LocationOptions> {
    final LocationOptions mLocationOptions;

    LocationUsingLocationServicesTask(@Nullable UUID taskID, TaskContext<LocationOptions> taskContext) {
        super(taskID, taskContext);

        mLocationOptions = taskContext.getOptions();
    }
}
