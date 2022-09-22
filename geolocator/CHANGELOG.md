## 9.0.2

- Updated dependency on geolocator_android to version 4.1.3
- Export `AndroidResource` class at `geolocator/lib/geolocator.dart.at`.

## 9.0.1

- Migrates to Dart SDK 2.15.0 and Flutter 2.8.0.

## 9.0.0

> **IMPORTANT:** when updating to version 9.0.0 make sure to also set the `compileSdkVersion` in the `android/app/build.gradle` file to `33`.

- Updated dependency on geolocator_android to version 4.0.0;
- Make sure the Android example app compiles against Android SDK 33.

## 8.2.1

- Fixes repository URL of the package.

## 8.2.0

- Adds support to make a foreground service on Android and continue processing location updates when the application is moved into the background.
- Ensures that the `getCurrentPosition` takes the supplied accuracy into account.
- Improves the speed of acquiring the current position on iOS.
- Added additional option to `AppleSettings` class to allow the user to configure the background location indicator of `CLocationManager`.

## 8.1.1

- Updated README.md to clarify the use of the geolocator_web package.

## 8.1.0

- Endorses the geolocator_windows package.

## 8.0.5

- Fix code coverage issues by adding iOS specific test for getCurrentPosition

## 8.0.4

- Export `ActivityType` at `geolocator.dart`

## 8.0.3

- Upgraded the geolocator_platform_interface, geolocator_web, geolocator_apple and geolocator_android packages to the latest versions.

## 8.0.2

- Updated README.md to clarify the use of platform specific packages.

## 8.0.1

- Fix "forceAndroidLocationManager" for getLastKnownPosition 
- Upgrade geolocator_platform_interface to 3.0.1
- Upgrade geolocator_web to 2.1.1

## 8.0.0

- Removed implicit request for permissions when getting a position.
- Updated README.md to clarify the use of the `Geolocator.checkPermission()` method.

## 7.7.1

* Update the documentation on permissions in the README.md.

## 7.7.0

> **IMPORTANT:** when updating to version 7.7.0 make sure to also set the compileSdkVersion in the android/app/build.gradle file to 31.

- Updated dependency on geolocator_android to version 2.0.0;
- Make sure the Android example App compiles against Android SDK 31.

## 7.6.2

- Migrate Android example App to mavenCentral as jFrog has sunset jCenter (see [official announcement](https://jfrog.com/blog/into-the-sunset-bintray-jcenter-gocenter-and-chartcenter) for more details);
- Upgrade Android example App to Gradle 4.1.0 to stay in sync with current stable version of Flutter.

## 7.6.1

- Refactored the example app and rollbacked the apple deployment target from 9.0 to 8.0.

## 7.6.0

- Make sure the `getCurrentPosition` method returns the current position and not a cached location which might be wrong (see issue [#629](https://github.com/Baseflow/flutter-geolocator/issues/629)). Note that this means that in some cases fetching the current position might take several seconds. If you want to have a fast initial result, call the `getLastKnownPosition` first and update the position with the result from `getCurrentPosition`.

## 7.5.0

- Added support for macOS Desktop.

## 7.4.1

- Updated README.md to include information about using the Geolocator web version in release mode.

## 7.4.0

- Moved to fully federated architecture (moved Android and iOS implementations into separate packages, geolocator_android and geolocator_apple respectivily).

## 7.3.1

- Android 10 and above: Fixed a bug causing the `requestPermission` method failing to show a prompt when requesting for background location permission.

## 7.3.0

- iOS 14: Users can now request Temporary Precise Location fetching by using the `requestTemporaryFullAccuracy()` method.

## 7.2.0+1

- Fix formatting of the CHANGELOG.md.

## 7.2.0

- iOS 14: Users can now query whether they gave permission for Approximate location fetching or Precise location fetching.

## 7.1.1

- Resolved a 404 error when clicking on the AndroidX migration link in the README.md.

## 7.1.0

- Added the locationServiceStream which fires an event if the location service of the device are disabled/enabled in the Android/iOS notification bar or in the Settings of the device.
- Updated the `geolocator_platform_interface: 2.1.1`

## 7.0.3

- Android: Throw the `ActivityMissingException` when requesting permissions while the activity is not available (e.g. when the App is in the background);
- iOS: Support the `NSLocationAlwaysAndWhenInUseUsageDescription` key on iOS 11+ (this key replaces the `NSLocationAlwaysDescription` key which has been marked [deprecated](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationalwaysusagedescription?language=objc)). 

## 7.0.2

- Upgrade to `geolocator_platform_interface: 2.0.1`

## 7.0.1

- Resolved bug when requesting permissions for the web (see issue [#673](https://github.com/Baseflow/flutter-geolocator/issues/673)).

## 7.0.0

This release contains the following **breaking changes**: 
- Stable release of null safety migration;
- Checking permissions on Android can no longer result in `LocationPermissions.deniedForever`. More details can be found in issue [#653](https://github.com/Baseflow/flutter-geolocator/issues/653) and the [wiki](https://github.com/Baseflow/flutter-geolocator/wiki/Breaking-changes-in-7.0.0#android-permission-update);
- Removed deprecated `timeInterval` parameter from the `getPositionStream` method;
- Removed deprecated global methods.

For detailed explanation of all breaking changes checkout the wiki page [Breacking changes in 7.0.0](https://github.com/Baseflow/flutter-geolocator/wiki/Breaking-changes-in-7.0.0).

## 6.2.1

- Solve bug causing error when requesting permissions (see issue [#673](https://github.com/Baseflow/flutter-geolocator/issues/673)).

## 6.2.0

- Added web support.

## 6.1.14

- iOS: Look for UIBackgroundModes location instead of having to register a separate `EnableBackgroundLocationUpdates` key in the Info.plist (see PR [#645](https://github.com/Baseflow/flutter-geolocator/pull/645)).

## 6.1.13

- Resolve deprecation warnings when building for Android.

## 6.1.12

- Added an example on how to access the current position of the device to the README.md (see issue [#615](https://github.com/Baseflow/flutter-geolocator/issues/615)).

## 6.1.11

- Solve issue on Android which can throw a `ConcurrentModificationException` when accessing locations simultaneously (see issue [#620](https://github.com/Baseflow/flutter-geolocator/issues/620)).

## 6.1.10

- Filter false positive notifications on Android indicating location services are not available (see issue [#585](https://github.com/Baseflow/flutter-geolocator/issues/585)).

## 6.1.9

- Return `LocationPermission.always` when requesting permission on Android 5.1 and below (see issue [#610](https://github.com/Baseflow/flutter-geolocator/issues/610)).

## 6.1.8+1

- Fixed Dart formatting issue.

## 6.1.8

- Deprecate the `timeInterval` parameter of the `getPositionStream` method in favor of the more semantic `intervalDuration` parameter.

## 6.1.7

- Resolved bug on Android where in some situations an IllegalArgumentException occures (see issue [#590](https://github.com/Baseflow/flutter-geolocator/issues/590)).

## 6.1.6

- Improved the example app to minimize code that is not relevant, and prevent confusions.

## 6.1.5

- Android: fixed issue where `checkPermission` reports permissions are `denied` when it should report permissions are `deniedForever` (see [#571](https://github.com/Baseflow/flutter-geolocator/issues/571))

## 6.1.4+1

- Hotfix to make sure the `CLLocation.speedAccuracy` property is only compiled when using Xcode 12 or higher (see [#577](https://github.com/Baseflow/flutter-geolocator/issues/577)).

## 6.1.4

- When available return the floor on which the devices is located (see [#562](https://github.com/Baseflow/flutter-geolocator/issues/562));
- When on iOS 10+ return information regarding the speed accuracy.

## 6.1.3

- Solves a bug causing less accurate location fixes (see [#531](https://github.com/Baseflow/flutter-geolocator/issues/531)).

## 6.1.2

- Allow developers to call the `getCurrentPosition` method while already listening to a position stream (see issue [#546](https://github.com/Baseflow/flutter-geolocator/issues/546));
- Make sure the position stream is stopped correctly (see issues [#485](https://github.com/Baseflow/flutter-geolocator/issues/485) and [#541](https://github.com/Baseflow/flutter-geolocator/issues/541));
- Android: fix deprecation warning (see issue [#556](https://github.com/Baseflow/flutter-geolocator/issues/556)).

## 6.1.1

- Android: throw `LocationServiceDisabledException` when location services are disabled while listening to the position update stream (see issue [#548](https://github.com/Baseflow/flutter-geolocator/issues/548)).

## 6.1.0

- Wrapped all global functions to a static class, thus changing the way geolocator methods should be called. (see issue [#524](https://github.com/Baseflow/flutter-geolocator/issues/524));
- Fix permission issue on Android where permisisons are reported "Denied forever" after selecting "One time" permission (see issue [#532](https://github.com/Baseflow/flutter-geolocator/issues/532));
- Added more detailed documentation on the `LocationServiceDisableException` (see issue [#519](https://github.com/Baseflow/flutter-geolocator/issues/519)).

## 6.0.0+4

- Android: fix crash when multiple permissions requests are make simultaneous (see issue [#513](https://github.com/Baseflow/flutter-geolocator/issues/513)).

## 6.0.0+3

- Make the `bearingBetween` and `distanceBetween` methods directly available from the geolocator package (see issue [#496](https://github.com/Baseflow/flutter-geolocator/issues/496));
- Android: check if permissions and grant results are available in `onRequestPermissionsResult` (see issue [#511](https://github.com/Baseflow/flutter-geolocator/issues/511))

## 6.0.0+2

- Add the `isMocked` field to the `Position` class to indicate if the position is retrieved using the Android MockLocationProvider (see issue [#498](https://github.com/Baseflow/flutter-geolocator/issues/498));
- Fix `IllegalArgumentException` on Android when using geolocator together with Firebase Analytics (see issue [#503](https://github.com/Baseflow/flutter-geolocator/issues/503));
- Fix a crash when denying permissions on iOS while receiving position updates (see issue [#497](https://github.com/Baseflow/flutter-geolocator/issues/497));
- Suppress warning when building App for Android (see issue [#502](https://github.com/Baseflow/flutter-geolocator/issues/502)).

## 6.0.0+1

- iOS: fixed issue converting integer to LocationPermission enum;

## 6.0.0

Complete rebuild of the geolocator plugin. Please note the this version contains breaking changes. The most important changes are:

- Better support for checking and requesting location permissions;
- Faster response when requesting location information;
- Added support to configure a timeout to cancel the position request;
- On Android the geolocator will now automatically prompt the user to enable the location services when they are disabled;
- Improved error handling. The geolocator will throw detailed exceptions explaining what went wrong (for example a `InvalidPermissionException` when you don't have permissions to request the position or the `LocationServiceDisabledException` when the location services are disabled);
- Improved documentation, especially regarding the configuration of permissions;
- IMPORTANT: geocoding features have been moved to their own plugin: [geocoding](https://pub.dev/packages/geocoding).

## 6.0.0-rc.4

- Upgrade to `geolocator_platform_interface: 1.0.2`

## 6.0.0-rc.3

- Fixed a bug where on Android the geolocator handles Activity messages that don't belong to the geolocator.

## 6.0.0-rc.2+1

- Fixed a typo causing a runtime exception when switching to the Android LocationManager.

## 6.0.0-rc.2

- Add support to force using the Android Location Manager instead of the Android FusedLocationProvider;
- Improved documentation.

## 6.0.0-rc.1

Complete rebuild of the geolocator plugin. Please note the this version contains breaking changes. The most important changes are:

- Better support for checking and requesting location permissions;
- Positions should be returned quickly;
- Added support to configure a timeout to cancel the position request;
- On Android the geolocator will now automatically prompt the user to enable the location services when they are disabled;
- Improved error handling. The geolocator will throw detailed exceptions explaining what went wrong (for example a `InvalidPermissionException` when you don't have permissions to request the position or the `LocationServiceDisabledException` when the location services are disabled).
- IMPORTANT: geocoding features have been moved to their own plugin: [geocoding](https://pub.dev/packages/geocoding).

## 5.3.1

- Update to `google_api_availability: 2.0.4`

## 5.3.0

- Added unit-tests to guard for breaking API changes;
- Added support to supply a locale identifier when requesting a placemark using a [Position](https://pub.dev/documentation/geolocator/latest/geolocator/Position-class.html) instance;
- **breaking*- Stop hiding parsing exceptions when converting coordinates into an address. Instead of returning `null` the `placemarkFromCoordinates` method will now throw and `ArgumentError` if illegal values are returned (which should never happen).

## 5.2.1

- Fixes a bug where `Placemark` instances where not correctly converted to json (thanks to @efraimrodrigues);
- Corrected a spelling mistake in the `CONTRIBUTING.md` file.

## 5.2.0

- iOS: keep trying to get the location when a `kCLErrorLocationUnknown` error is received (as per Apple's [documentation](https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423786-locationmanager));
- Android: synchronize gradle versions with current stable version of Flutter (1.12.13+hotfix.5).

## 5.1.5

- Android: Fixes bug where latitude and longitude are not returned as part of the placemark (thanks to @slightfood).

## 5.1.4+2

- Return the heading on iOS correctly.

## 5.1.4+1

- Downgrade the "meta" package to version 1.7.0 since pub.dev static code analysis reports errors.

## 5.1.4

- Added support for Android 10’s background location permission;
- Return heading as part of the position on iOS.

## 5.1.3

- Added integration with public Bitrise CI project;
- Fixed two analysis warnings;
- Fixed a spelling error in docs.

## 5.1.2

- Added new method to calculate bearing given two points.

## 5.1.1+1

- Reverted the update of the 'meta' plugin as Flutter SDK depends on old version.

## 5.1.1

- Updated dependency on 'meta' plugin to latest version.

## 5.1.0

- Change geocoding results on Android to return multiple records;
- Extended the example application;
- Use the correct permission level enumeration;
# Added documentation regarding AndroidX support.


## 5.0.1

- Make sure the stream channel is closed when Android activity is destroyed;
- Allow developers to specify the permission level they want to use when requesting permissions on iOS.

## 5.0.0

- Converted the iOS version from Swift to Objective-C, reducing the size of the final binary considerably, as well as solve some compatibility issues with other objective-c based plugins;
- Fetch geocoding results on a separate thread not to slow down the main thread;
- Bug fix where the current location could not be determined on non-GPS enabled phones;
- Update to use latest gradle version.

## 4.0.3

- Update to latest version of the Location Permissions plugin to solve a bug when permissions are sometimes not requested.

## 4.0.2

- Bug fix on Android which causing the `Reply already submitted` error;
- Updated `location_permission` plugin to version `2.0.0`.

## 4.0.1

- Updated to latest version of the Location Permissions plugin (1.1.0).

## 4.0.0

- Overhauled the permissions system to make sure the plugin only depends on the location API. This means when using this version of the plugin Apple requires only entries for the `NSLocationWhenInUseUsageDescription` and/ or `NSLocationAlwaysUsageDescription` in the `Info.plist`.
- **breaking*- As part of the permission system overhaul, we removed the `disabled` permission status. To check if the location services are running you should call the `isLocationServiceEnabled` method. This means you can now also request permissions when the location services are disabled.

## 3.0.1

- Updated dependencies on Permission Handler and Google API Availability to remove Kotlin dependency.

## 3.0.0

- **breaking*- Updated to support AndroidX;
- Added API method `isLocationServiceEnabled` to check if location services are enabled or disabled
- Removed method `checkGeolocationStatus` (marked deprecated in version 1.6.4);
- Updated to latest version of Permission Handler plugin to solve some small issues on iOS;
- Added Swift version number to podspec file;
- Added ProGuard support for Android;
- Updated static code analyses to confirm to latest recommendations from Flutter team.

## 2.1.1

- Updated iOS code to Swift 4.2
- Updated to latest version of the permission_handler plugin (v2.1.2)

## 2.1.0

- Updated dependencies on Permission Handler and Google API Availability plugins.

## 2.0.2

- Updated Gradle version

## 2.0.1

- Bug fix where a null reference exception occurs because the timestamp of the `Position` could be `null` when fetching a `Placemark` using the `placemarkFromAddress` or `placemarkFromCoordinates` methods.

## 2.0.0

- **breaking*- The `getPositionStream` method now directly returns an instance of the `Stream<Position>` class, meaning there is no need to `await` the method before being able to access the stream;
- **breaking*- Arguments for the methods `getCurrentPosition` and `getLastKnownPosition` are now named optional parameters instead of positional optional parameters;
- By default Geolocator will use FusedLocationProviderClient on Android when Google Play Services are available. It will fall back to LocationManager when it is not available. You can override the behaviour by setting `Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;`
- Allow developers to specify a desired interval for active location updates, in milliseconds (Android only).

## 1.7.0

- Added timestamp to instances of the `Position` class indicating when the GPS fix was acquired;
- Updated the dependency on the `PermissionHandler` to version >=2.0.0 <3.0.0. 

## 1.6.5

- Fixed bug on Android when not supplying a locale while using the  Geocoding features.

## 1.6.4

- Added support to supply a locale when using the `placemarkFromAddress` and `placemarkFromCoordinates` methods.
- Deprecated the static method `checkGeolocationStatus` in favor of the instance method `checkGeolocationPermissionStatus` (the static version will be removed in version 2.0 of the Geolocator plugin).

## 1.6.3

- Added feature to check the availability of Google Play services on the device (using the `checkGooglePlayServicesAvailability` method). This will allow developers to implement a more user friendly experience regarding the usage of Google Play services (for more information see the article [Set Up Google Play Services](https://developers.google.com/android/guides/setup));
- Fixed the error `'List<dynamic>' is not a subtype of type 'Future<dynamic>'` on Flutter 0.6.2 and higher (thanks @fawadkhanucp for reporting the issue and solution);
- Fixed an error when calling the `getCurrentPosition`, `getPositionStream`, `placemarkFromAddress` and `placemarkFromCoordinates` from an Android background service (thanks @sestegra for reporting the issue and creating a pull-request).

## 1.6.2

- Hot fix to solve cast exception

## 1.6.1

- Fixed a bug which caused stationary location updates not to be streamed when using the new `FusedLocationProviderClient` on Android (thanks @audkar for the PR).

## 1.6.0

- Use the Location Services (through the `FusedLocationProviderClient`) on Android if available, otherwise fallback to the `LocationManager` class;
- Make sure that on Android the last know location is returned immediately on the stream when requesting location updates through the `getPositionStream` method;
- Updated documentation on adding location permissions on Android.

## 1.5.0

- It is now possible to check the location permissions using the `checkGeolocationStatus` method [[ISSUE #51](https://github.com/BaseflowIT/flutter-geolocator/issues/51)].
- Improved the example App [[ISSUE #54](https://github.com/BaseflowIT/flutter-geolocator/issues/54)]
- Solved a bug on Android causing a memory leak when you stop listening to the position stream.
- **breaking*- Solved a bug on Android where permissions could be requested more then once simultaneously [[ISSUE #58](https://github.com/BaseflowIT/flutter-geolocator/issues/58)]
- Solved a bug on Android where requesting permissions twice would cause the App to crash [[ISSUE #61](https://github.com/BaseflowIT/flutter-geolocator/issues/61)]

> **Important:**
> 
> To be able to correctly fix [issue #58](https://github.com/BaseflowIT/flutter-geolocator/issues/58) we had to change the `getPositionStream` method into a `async` method. This means the signature of the method has been changed from:
>
> `Stream<Position> getPositionStream([LocationOptions locationOptions = const LocationOptions()])` 
>
> to 
>
> `Future<Stream<Position>> getPositionStream([LocationOptions locationOptions = const LocationOptions()])`. 
>
> Meaning as a developer you'll now have to `await` the result of the method to get access to the actual stream.

## 1.4.0

- Added feature to query the last known location that is stored on the device using the `getLastKnownLocation` method;
- **breaking*- Renamed the `getPosition` to `getCurrentPosition`;
- Fixed bug where calling `getCurrentPosition` on Android resulted in returning the last known location;
- **breaking*- Renamed methods `toPlacemark` and `fromPlacemark` respectively to the, more meaningful names, `placemarkFromAddress` and `placemarkFromCoordinates`;

## 1.3.1

- Added support for iOS `kCLLocationAccurayBestForNavigation` (defaults to `best` when on Android).

## 1.3.0

- Added the option to check the distance between two geocoordinates (using the `distanceBetween` method).

## 1.2.2

- Make sure that an Android App using the plugin is informed when the platform stops transmitting location updates.

## 1.2.1

- Added feature to throttle the amount of locations updates based on a supplied distance filter.

> **Important:**
>
> This introduces a breaking change since the signature of the `getPositionStream` has changed from `getPositionStream(LocationAccuracy accuracy)` to
> `getPositionStream(LocationOptions locationOptions)` .

-  Made some small changes to ensure the plugin no longer is depending on JAVA 8, meaning the plugin will run using the default Android configuration.

## 1.2.0

- Added support to translate an address into geocoordinates and vice versa (a.k.a. Geocoding). See the [README.md](README.md) file for more information.

## 1.1.2

- Fixed reported formatting issues

## 1.1.1

- Fixed a warning generated by xCode when compiling the example project (see [issue #28](https://github.com/BaseflowIT/flutter-geolocator/issues/28))
- Fixed some warnings generated by Dart static code analyser, improving code quality

## 1.1.0

- Introduced the option to supply a desired accuracy. 

> **Important:*- 
>
>This introduces a breaking change, the `getPosition` and `onPositionChanged` properties have been replaced by methods (`getPosition([LocationAccuracy desiredAccuracy = LocationAccuracy.Best])` and `getPositionStream([LocationAccuracy desiredAccuracy = LocationAccuracy.Best])` respectively) accepting a parameter to indicate the desired accuracy.
- Updated the Android part to make use of the [LocationManager](https://developer.android.com/reference/android/location/LocationManager) instead of the [FusedLocationProviderClient](https://developers.google.com/android/reference/com/google/android/gms/location/FusedLocationProviderClient)
- Improved support for handling position requests that happen in rapid succession.

## 1.0.0

- Updated documentation
- API defined stable

## 0.0.2

- Solved problem with missing geolocator-Swift.h header file (see also issue [Flutter#16049](https://github.com/flutter/flutter/issues/16049)).

## 0.0.1

- Initial release
