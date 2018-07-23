package com.baseflow.flutter.plugin.geolocator.data;

import com.google.gson.annotations.SerializedName;

public enum GeolocationAccuracy {
    @SerializedName("lowest")
    Lowest,
    @SerializedName("low")
    Low,
    @SerializedName("medium")
    Medium,
    @SerializedName("high")
    High,
    @SerializedName(value = "best", alternate = "bestForNavigation")
    Best
}
