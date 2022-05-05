## 3.1.8

- Ensures that when Google mobile services are globally excluded as a dependency to automatically fallback to the Android LocationManager.

## 3.1.7

- Fixes repository URL of the package.

## 3.1.6

- Switches to a package-internal implementation of the platform interface.

## 3.1.5

- Fixes potential cast exceptions when connecting to the location service.

## 3.1.4

- Fixes support for retrieving the position stream in the absence of an Android activity.

## 3.1.3

- Fixes a bug introduced in 3.1.2 where unregistering the status location receiver throws an IllegalArgumentException.

## 3.1.2

- Fixes an issue with the location status service not unregistering the status receiver.

## 3.1.1

- Fixes an issue with the foreground service connection not getting unbound correctly.

## 3.1.0

- Adds support to make a foreground service and continue processing location updates when the application is moved into the background.

## 3.0.4

- Fixes Android embedding v2 warning when compiling the example App.

## 3.0.3

- Added a default `intervalDuration` value of 5000ms to prevent the `getCurrentPosition` method to return a cached Location.

## 3.0.2

- Updated to the latest version of the `geolocator_platform_interface': `4.0.0`.

## 3.0.1

- Replace usage of unofficial GMS library

## 3.0.0+4

- Resolve merge conflict.

## 3.0.0+3

- Fixes cast exception when converting Integer to Long.

## 3.0.0+2

- Fixes NPE when accessing the position stream.

## 3.0.0+1

- Adds `intervalDuration` to the `AndroidSettings` class.

## 3.0.0

- Removed implicit request for permissions when getting a position.
- Added the [AndroidOptions] class to the `lib` directory.
- Added the `forceLocationManager` property to the [AndroidOptions] instance.

## 2.1.0

- Added Approximate Location support for Android 12;
- Added support to request the location accuracy on Android through the `Geolocator.getLocationAccuracy()` method;
- Make sure the `getServiceStatusStream` method returns an event when initially the Service Status is enabled on Android Devices (see issue[#812](https://github.com/Baseflow/flutter-geolocator/issues/812).

## 2.0.0

> **IMPORTANT:** when updating to version 2.0.0 make sure to also set the compileSdkVersion in the app/build.gradle file to 31.

- Set Android `compileSdkVersion` to `31` (Android 12);
- Fixed the deprecation warnings/errors which caused the `flutter build appbundle` to fail when using `compileSdkVersion 31`.

## 1.0.2

- Fixed **didChangeAppLifecycleState** goes into a loop after location request (see issue: https://github.com/Baseflow/flutter-geolocator/issues/816).

## 1.0.1

- Migrate to mavenCentral as jFrog has sunset jCenter (see [official announcement](https://jfrog.com/blog/into-the-sunset-bintray-jcenter-gocenter-and-chartcenter) for more details);
- Upgrade to Gradle 4.1.0 to stay in sync with current stable version of Flutter.

## 1.0.0

- Initial open source release.
