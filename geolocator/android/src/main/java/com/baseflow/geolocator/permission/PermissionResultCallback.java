package com.baseflow.geolocator.permission;

@FunctionalInterface
public interface PermissionResultCallback {
    public void onResult(LocationPermission permission);
}
