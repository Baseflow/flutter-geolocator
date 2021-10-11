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

