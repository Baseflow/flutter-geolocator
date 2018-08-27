package com.baseflow.flutter.plugin.geolocator.data;

import com.google.gson.annotations.SerializedName;

public enum GeolocationAccuracy {
    @SerializedName("lowest")
    LOWEST,
    @SerializedName("low")
    LOW,
    @SerializedName("medium")
    MEDIUM,
    @SerializedName("high")
    HIGH,
    @SerializedName(value = "best", alternate = "bestForNavigation")
    BEST
}
