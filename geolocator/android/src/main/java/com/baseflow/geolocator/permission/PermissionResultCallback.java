package com.baseflow.geolocator.permission;

@FunctionalInterface
public interface PermissionResultCallback {
  void onResult(LocationPermission permission);
}
