## 2.2.5

* Fixes a bug where iOS location manager background geolocation settings are overridden by calls to the `getCurrentPosition` method.

## 2.2.4

* Fix plugin registration in `dart_plugin_registrant.dart`

## 2.2.3

* Implement allowBackgroundLocationUpdates iOS setting

## 2.2.2

* Fix requesting location while listening to location stream stops the stream

## 2.2.1

* Migrates to Dart SDK 2.15.0 and Flutter 2.8.0.

## 2.2.0

* Raises minimum Dart version to 2.17 and Flutter version to 3.0.0.
* Updates `isMocked` flag on iOS 15 and higher.
* Updates the example application to request permissions when start listening to the position stream.

## 2.1.4

* Fix background location indicator not showing on first time using the service.

## 2.1.3

* Fixes repository URL of the package.

## 2.1.2

* Switches to a package-internal implementation of the platform interface.

## 2.1.1+1

* Resolves issue with symbolic links in 2.1.1 version.

## 2.1.1

* Added additional option to Apple settings to allow the user to configure the background location indicator of CLocationManager.

## 2.1.0

* Ensures that the `getCurrentPosition` takes the supplied accuracy into account.
* Improves the speed of acquiring the current position.
* Adds a native test bed.

## 2.0.1

* Updated to the latest version of the `geolocator_platform_interface': `4.0.0`.

## 2.0.0+2

* Removes the Android specific `timeInterval` parameter from `AppleSettings`.

## 2.0.0+1

* Adds missing `timeLimit` to the `AppleSettings` class.

## 2.0.0

* iOS: Keep `PositionStream` alive when the `Location Services` has been turned off and on again in the settings.
* Removed implicit request for permissions when getting a position.
* Added the [ActivityType] enum needed for the `pauseLocationUpdatesAutomatically` property.
* Added the `pauseLocationUpdatesAutomatically` and `activityType` property to the iOS options class.

## 1.2.2

* Fixed iOS cancelation of positionStream.

## 1.2.1

* Use `requestAlwaysAuthorization` instead of `requestWhenInUseAuthorization` on macOS as both result in the same behaviour but the former has better support on Catelina.

## 1.2.0

* Make sure the `getCurrentPosition` method returns the current position and not a cached location which might be wrong (see issue [#629](https://github.com/Baseflow/flutter-geolocator/issues/629)).

## 1.1.0

* Added support for macOS Desktop.

## 1.0.0

* Initial open source release.
