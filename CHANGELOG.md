## [5.3.1]

* Update to `google_api_availability: 2.0.4`

## [5.3.0]

* Added unit-tests to guard for breaking API changes;
* Added support to supply a locale identifier when requesting a placemark using a [Position](https://pub.dev/documentation/geolocator/latest/geolocator/Position-class.html) instance;
* **breaking** Stop hiding parsing exceptions when converting coordinates into an address. Instead of returning `null` the `placemarkFromCoordinates` method will now throw and `ArgumentError` if illigal values are returned (which should never happen).

## [5.2.1]

* Fixes a bug where `Placemark` instances where not correctly converted to json (thanks to @efraimrodrigues);
* Corrected a spelling mistake in the `CONTRIBUTING.md` file.

## [5.2.0]

* iOS: keep trying to get the location when a `kCLErrorLocationUnknow` error is received (as per Apple's [documentation](https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423786-locationmanager));
* Android: synchronize gradle versions with current stable version of Flutter (1.12.13+hotfix.5).

## [5.1.5]

* Android: Fixes bug where latitude and longitude are not returned as part of the placemark (thanks to @slightfood).

## [5.1.4+2]

* Return the heading on iOS correctly.

## [5.1.4+1]

* Downgrade the "meta" package to version 1.7.0 since pub.dev static code analysis reports errors.

## [5.1.4]

* Added support for Android 10’s background location permission;
* Return heading as part of the position on iOS.

## [5.1.3]

* Added integration with public Bitrise CI project;
* Fixed two analysis warnings;
* Fixed a spelling error in docs.

## [5.1.2]

* Added new method to calculate bearing given two points.

## [5.1.1+1]

* Reverted the update of the 'meta' plugin as Flutter SDK depends on old version.

## [5.1.1]

* Updated dependency on 'meta' plugin to latest version.

## [5.1.0]

* Change geocoding results on Android to return multiple records;
* Extended the example application;
* Use the correct permission level enumeration;
# Added documentation regarding AndroidX support.


## [5.0.1]

* Make sure the stream channel is closed when Android activity is destroyed;
* Allow developers to specify the permission level they want to use when requesting permissions on iOS.

## [5.0.0]

* Converted the iOS version from Swift to Objective-C, reducing the size of the final binary considerably, as well as solve some compatibility issues with other objective-c based plugins;
* Fetch geocoding results on a separate thread not to slow down the main thread;
* Bug fix where the current location could not be determined on non-GPS enabled phones;
* Update to use latest gradle version.

## [4.0.3]

* Update to latest version of the Location Permissions plugin to solve a bug when permissions are sometimes not requested.

## [4.0.2]

* Bug fix on Android which causing the `Reply already submitted` error;
* Updated `location_permission` plugin to version `2.0.0`.

## [4.0.1]

* Updated to latest version of the Location Permissions plugin (1.1.0).

## [4.0.0]

* Overhauled the permissions system to make sure the plugin only depends on the location API. This means when using this version of the plugin Apple requires only entries for the `NSLocationWhenInUseUsageDescription` and/ or `NSLocationAlwaysUsageDescription` in the `Info.plist`.
* **breaking** As part of the permission system overhaul, we removed the `disabled` permission status. To check if the location services are running you should call the `isLocationServiceEnabled` method. This means you can now also request permissions when the location services are disabled.

## [3.0.1]

* Updated dependencies on Permission Handler and Google API Availability to remove Kotlin dependency.

## [3.0.0]

* **breaking** Updated to support AndroidX;
* Added API method `isLocationServiceEnabled` to check if location services are enabled or disabled
* Removed method `checkGeolocationStatus` (marked deprecated in version 1.6.4);
* Updated to latest version of Permission Handler plugin to solve some small issues on iOS;
* Added Swift version number to podspec file;
* Added ProGuard support for Android;
* Updated static code analyses to confirm to latest recommendations from Flutter team.

## [2.1.1]

* Updated iOS code to Swift 4.2
* Updated to latest version of the permission_handler plugin (v2.1.2)

## [2.1.0]

* Updated dependencies on Permission Handler and Google API Availability plugins.

## [2.0.2]

* Updated Gradle version

## [2.0.1]

* Bug fix where a null reference exception occurs because the timestamp of the `Position` could be `null` when fetching a `Placemark` using the `placemarkFromAddress` or `placemarkFromCoordinates` methods.

## [2.0.0]

* **breaking** The `getPositionStream` method now directly returns an instance of the `Stream<Position>` class, meaning there is no need to `await` the method before being able to access the stream;
* **breaking** Arguments for the methods `getCurrentPosition` and `getLastKnownPosition` are now named optional parameters instead of positional optional parameters;
* By default Geolocator will use FusedLocationProviderClient on Android when Google Play Services are available. It will fall back to LocationManager when it is not available. You can override the behaviour by setting `Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;`
* Allow developers to specify a desired interval for active location updates, in milliseconds (Android only).

## [1.7.0]

* Added timestamp to instances of the `Position` class indicating when the GPS fix was acquired;
* Updated the dependency on the `PermissionHandler` to version >=2.0.0 <3.0.0. 

## [1.6.5]

* Fixed bug on Android when not supplying a locale while using the  Geocoding features.

## [1.6.4]

* Added support to supply a locale when using the `placemarkFromAddress` and `placemarkFromCoordinates` methods.
* Deprecated the static method `checkGeolocationStatus` in favor of the instance method `checkGeolocationPermissionStatus` (the static version will be removed in version 2.0 of the Geolocator plugin).

## [1.6.3]

* Added feature to check the availability of Google Play services on the device (using the `checkGooglePlayServicesAvailability` method). This will allow developers to implement a more user friendly experience regarding the usage of Google Play services (for more information see the article [Set Up Google Play Services](https://developers.google.com/android/guides/setup));
* Fixed the error `'List<dynamic>' is not a subtype of type 'Future<dynamic>'` on Flutter 0.6.2 and higher (thanks @fawadkhanucp for reporting the issue and solution);
* Fixed an error when calling the `getCurrentPosition`, `getPositionStream`, `placemarkFromAddress` and `placemarkFromCoordinates` from an Android background service (thanks @sestegra for reporting the issue and creating a pull-request).

## [1.6.2]

* Hot fix to solve cast exception

## [1.6.1]

* Fixed a bug which caused stationary location updates not to be streamed when using the new `FusedLocationProviderClient` on Android (thanks @audkar for the PR).

## [1.6.0]

* Use the Location Services (through the `FusedLocationProviderClient`) on Android if available, otherwise fallback to the `LocationManager` class;
* Make sure that on Android the last know location is returned immediately on the stream when requesting location updates through the `getPositionStream` method;
* Updated documentation on adding location permissions on Android.

## [1.5.0]

* It is now possible to check the location permissions using the `checkGeolocationStatus` method [[ISSUE #51](https://github.com/BaseflowIT/flutter-geolocator/issues/51)].
* Improved the example App [[ISSUE #54](https://github.com/BaseflowIT/flutter-geolocator/issues/54)]
* Solved a bug on Android causing a memory leak when you stop listening to the position stream.
* **breaking** Solved a bug on Android where permissions could be requested more then once simultaniously [[ISSUE #58](https://github.com/BaseflowIT/flutter-geolocator/issues/58)]
* Solved a bug on Android where requesting permissions twice would cause the App to crash [[ISSUE #61](https://github.com/BaseflowIT/flutter-geolocator/issues/61)]

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

## [1.4.0]

* Added feature to query the last known location that is stored on the device using the `getLastKnownLocation` method;
* **breaking** Renamed the `getPosition` to `getCurrentPosition`;
* Fixed bug where calling `getCurrentPosition` on Android resulted in returning the last known location;
* **breaking** Renamed methods `toPlacemark` and `fromPlacemark` respectively to the, more meaningfull names, `placemarkFromAddress` and `placemarkFromCoordinates`;

## [1.3.1]

* Added support for iOS `kCLLocationAccurayBestForNavigation` (defaults to `best` when on Android).

## [1.3.0]

* Added the option to check the distance between two geocoordinates (using the `distanceBetween` method).

## [1.2.2]

* Make sure that an Android App using the plugin is informed when the platform stops transmitting location updates.

## [1.2.1]

* Added feature to throttle the amount of locations updates based on a supplied distance filter.

> **Important:**
>
> This introduces a breaking change since the signature of the `getPositionStream` has changed from `getPositionStream(LocationAccuracy accuracy)` to
> `getPositionStream(LocationOptions locationOptions)` .

*  Made some small changes to ensure the plugin no longer is depending on JAVA 8, meaning the plugin will run using the default Android configuration.

## [1.2.0]

* Added support to translate an address into geocoordinates and vice versa (a.k.a. Geocoding). See the [README.md](README.md) file for more information.

## [1.1.2]

* Fixed reported formatting issues

## [1.1.1]

* Fixed a warning generated by xCode when compiling the example project (see [issue #28](https://github.com/BaseflowIT/flutter-geolocator/issues/28))
* Fixed some warnings generated by Dart static code analyser, improving code quality

## [1.1.0]

* Introduced the option to supply a desired accuracy. 

> **Important:** 
>
>This introduces a breaking change, the `getPosition` and `onPositionChanged` properties have been replaced by methods (`getPosition([LocationAccuracy desiredAccuracy = LocationAccuracy.Best])` and `getPositionStream([LocationAccuracy desiredAccuracy = LocationAccuracy.Best])` respectively) accepting a parameter to indicate the desired accuracy.
* Updated the Android part to make use of the [LocationManager](https://developer.android.com/reference/android/location/LocationManager) instead of the [FusedLocationProviderClient](https://developers.google.com/android/reference/com/google/android/gms/location/FusedLocationProviderClient)
* Improved support for handling position requests that happen in rapid succession.

## [1.0.0]

* Updated documentation
* API defined stable

## [0.0.2]

* Solved problem with missing geolocator-Swift.h header file (see also issue [Flutter#16049](https://github.com/flutter/flutter/issues/16049)).

## [0.0.1]

* Initial release
