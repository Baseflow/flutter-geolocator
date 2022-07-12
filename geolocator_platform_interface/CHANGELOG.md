## 4.0.6

- Migrates to Dart SDK 2.15.0 and Flutter 2.8.0.

## 4.0.5

- Fixes repository URL of the package.

## 4.0.4

- Fixes a bug where listening to the position stream immediately after an error, results in listening to a dead stream. 

## 4.0.3

- Removes `timeInterval` from `LocationSettings` documentation.

## 4.0.2

- Added `extensions.dart` to the `exports` list.

## 4.0.1

- Adds the `LocationPermission.unableToDetermine` status used on the web platform when the permission API is not implemented by the browser.

## 4.0.0

- **breaking** Updates the plugin platform interface to use a non`-const` token. This is marked as a breaking change because it can cause an assertion failure if implementations use `implements` rather than `extends`, but hopefully there aren't any of those;
- Replaced soft-deprecated `PlatformInterface.verifyToken` method with `PlatformInterface.verify` method;
- Updated `plugin_platform_interface` dependency.


## 3.0.1

- Remove unnecessary import statements from several source files;
- Fix "forceAndroidLocationManager" for getLastKnownPosition.

## 3.0.0+1

- Removed Android specific `LocationSettings.intervalDuration` field.

## 3.0.0

- Defines the `LocationSettings` class which bundles platform specific settings when communicating with the host platform.

## 2.3.6

- Updated API documentation on `GeolocatorPlatform.getServiceStream()` method, describing it is not supported on the web platform.

## 2.3.5

- Changed the EventChannelMock and the MethodChannelMockd due to breaking changes in the platform channel test interface.

## 2.3.4

- Update the documentation of the `getCurrentPosition` method to explain why it can take several seconds to execute.

## 2.3.3

- Migrated to [flutter_lints](https://pub.dev/packages/flutter_lints) as linter rule set as it replaces the deprecated [effective_dart](https://pub.dev/packages/effective_dart) package.

## 2.3.2

- Added the possibility to pass your own purposeKey name to the requestTemporaryFullAccuracy method.

## 2.3.1

- Solves a bug which resulted in an issue when closing the position stream.

## 2.3.0

- Added the possibility to request temporary Precise Accuracy on iOS 14+ devices.

## 2.2.1

- Documentation `getLocationAccuracy()` method clarified.
- Extended the `LocationAccuracyStatus` enum with a `LocationAccuracyStatus.unknown` value, which can be used by platforms that don't support location accuracy features.

## 2.2.0

- Added the possibility to query for the LocationAccuracyStatus on devices running iOS 14.0 and higher.

## 2.1.1

- Solves a bug which resulted in an issue when closing the position stream and requesting a new one (see issue [#703](https://github.com/Baseflow/flutter-geolocator/issues/703)).

## 2.1.0

- Added the possibility to start a stream which will return an event when Location Services are manually enabled/disabled

## 2.0.2

- Added definition of the `ActivityMissingException`.

## 2.0.1

- Resolved analyzer error when using mockito (see issue [#709](https://github.com/Baseflow/flutter-geolocator/issues/709)).

## 2.0.0

- Stable release for null safety.

## 2.0.0-nullsafety.1

- Merged version 1.0.9 into null safety.

## 2.0.0-nullsafety.0

- Migrated to support null safety.

## 1.0.9

- Updated the README.md to more clearly explain the purpose of the geolocator_platform_interface package.

## 1.0.8

- Added the optional floor property to the position model and can be used by implementations to specify the floor on which the device is located (see [#562](https://github.com/Baseflow/flutter-geolocator/issues/562)).

## 1.0.7

- Solves a bug causing less accurate location fixes (see [#531](https://github.com/Baseflow/flutter-geolocator/issues/531)).

## 1.0.6+1

- Solve a bug which adds a zero timeout when no timeout is supplied (see [#564]((https://github.com/Baseflow/flutter-geolocator/issues/564))).

## 1.0.6

- Allow developers to call the `getCurrentPosition` method while already listening to a position stream (see issue [#546](https://github.com/Baseflow/flutter-geolocator/issues/546));
- Make sure the position stream is stopped correctly (see issues [#485](https://github.com/Baseflow/flutter-geolocator/issues/485) and [#541](https://github.com/Baseflow/flutter-geolocator/issues/541));
- Android: fix deprecation warning (see issue [#556](https://github.com/Baseflow/flutter-geolocator/issues/556)).

## 1.0.5

- Added more detailed documentation on the `LocationServiceDisableException` (see issue [#519](https://github.com/Baseflow/flutter-geolocator/issues/519)).

## 1.0.4

- Add the `isMocked` field to the `Position` class to indicate if the position is retrieved using the Android MockLocationProvider (see issue #498);
- Fixed typo in API documentation of LocationPermission (see issue #494)

## 1.0.3+1

- Improved LocationPermission documentation (see issue #494).

## 1.0.3

- Fixed code formatting and homepage URL

## 1.0.2

- Make sure close streams are dereferenced (solves a bug where closed stream is listened to generating an exception).

## 1.0.1

- Add support to force using the Android Location Manager instead of the Android FusedLocationProvider.

## 1.0.0

- Initial open-source release.
