## 2.3.9

* Adds privacy manifest for macOS.

## 2.3.8+1

* HOT FIX: Adds back implementation of the `stopListening` method in the `GeolocationHandler.m` file.

## 2.3.8

* Uses different `CLLocationManager` instances, for one time request location and persistent request location. 
* Fixes a bug where iOS location settings, e.g. `accuracy` and `distanceFilter` are overridden by different calls.
* Updates minimum deployment target to `iOS 11` as lower is not supported anymore by Xcode.

## 2.3.7

* Adds privacy manifest.

## 2.3.6

* Adds option to bypass the request for permission to update location in the background (which can attract scrutiny from Apple upon app submission). To bypass, set the preprocessor macro `BYPASS_PERMISSION_LOCATION_ALWAYS` to 1 in XCode.

## 2.3.5

* Previously the plugin filtered out negative values for heading and/or heading accuracy. Now the plugin is returning the heading and/or the heading accuracy even if the they have a negative value (invalid), so that the developer can use it and decide what to do with it.

## 2.3.4

* Allows the ARM64 architecture as a valid IPhone simulator architecture.

## 2.3.3

* Ensures the `[CLLocationManager locationServicesEnabled]` message is called
on a background thread when listening for service updates.

## 2.3.2

* Fixes build error and warnings regarding unused variables and unavailable APIs on macOS.

## 2.3.1

* Fixes a bug where invalid speed and speed accuracy readings where returned instead of ignored.

## 2.3.0

* Includes `altitudeAccuracy` and `headingAccuracy` in `Position`.

## 2.2.7

* Fixes the propagation of the activity type setting.

## 2.2.6

* Ensures the `isLocationServicesEnabled` method is executed in a background thread.

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
