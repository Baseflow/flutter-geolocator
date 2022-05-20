## 2.1.4

- Fix background location indicator not showing on first time using the service.

## 2.1.3

- Fixes repository URL of the package.

## 2.1.2

- Switches to a package-internal implementation of the platform interface.

## 2.1.1+1

- Resolves issue with symbolic links in 2.1.1 version.

## 2.1.1

- Added additional option to Apple settings to allow the user to configure the background location indicator of CLocationManager.

## 2.1.0

- Ensures that the `getCurrentPosition` takes the supplied accuracy into account.
- Improves the speed of acquiring the current position.
- Adds a native test bed.

## 2.0.1

- Updated to the latest version of the `geolocator_platform_interface': `4.0.0`.

## 2.0.0+2

- Removes the Android specific `timeInterval` parameter from `AppleSettings`.

## 2.0.0+1

- Adds missing `timeLimit` to the `AppleSettings` class.

## 2.0.0

- iOS: Keep `PositionStream` alive when the `Location Services` has been turned off and on again in the settings.
- Removed implicit request for permissions when getting a position.
- Added the [ActivityType] enum needed for the `pauseLocationUpdatesAutomatically` property.
- Added the `pauseLocationUpdatesAutomatically` and `activityType` property to the iOS options class.

## 1.2.2

- Fixed iOS cancelation of positionStream.

## 1.2.1

- Use `requestAlwaysAuthorization` instead of `requestWhenInUseAuthorization` on macOS as both result in the same behaviour but the former has better support on Catelina.

## 1.2.0

- Make sure the `getCurrentPosition` method returns the current position and not a cached location which might be wrong (see issue [#629](https://github.com/Baseflow/flutter-geolocator/issues/629)).

## 1.1.0

- Added support for macOS Desktop.

## 1.0.0

- Initial open source release.
