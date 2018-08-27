package com.baseflow.flutter.plugin.geolocator.data;

import com.google.gson.annotations.SerializedName;

public enum PlayServicesAvailability {
    @SerializedName("success")
    SUCCESS,
    @SerializedName("serviceMissing")
    SERVICE_MISSING,
    @SerializedName("serviceUpdating")
    SERVICE_UPDATING,
    @SerializedName("serviceVersionUpdateRequired")
    SERVICE_VERSION_UPDATE_REQUIRED,
    @SerializedName("serviceDisabled")
    SERVICE_DISABLED,
    @SerializedName("serviceInvalid")
    SERVICE_INVALID,
    @SerializedName("unknown")
    UNKNOWN
}
