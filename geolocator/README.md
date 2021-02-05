# Flutter Geolocator Plugin  

[![pub package](https://img.shields.io/pub/v/geolocator.svg)](https://pub.dartlang.org/packages/geolocator) ![Geolocator](https://github.com/Baseflow/flutter-geolocator/workflows/Geolocator/badge.svg?branch=master) [![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart) [![codecov](https://codecov.io/gh/Baseflow/flutter-geolocator/branch/master/graph/badge.svg)](https://codecov.io/gh/Baseflow/flutter-geolocator)

A Flutter geolocation plugin which provides easy access to platform specific location services ([FusedLocationProviderClient](https://developers.google.com/android/reference/com/google/android/gms/location/FusedLocationProviderClient) or if not available the [LocationManager](https://developer.android.com/reference/android/location/LocationManager) on Android and [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager) on iOS).

## Features

* Get the last known location;
* Get the current location of the device;
* Get continuous location updates;
* Check if location services are enabled on the device;
* Calculate the distance (in meters) between two geocoordinates;
* Calculate the bearing between two geocoordinates;

> **IMPORTANT:**
>
> Starting from version 6.0.0 the geocoding features (`placemarkFromAddress` and `placemarkFromCoordinates`) are no longer part of the geolocator plugin. We have moved these features to their own plugin: [geocoding](https://pub.dev/packages/geocoding). This new plugin is an improved version of the old methods.

## Usage

To add the geolocator to your Flutter application read the [install](https://pub.dev/packages/geolocator/install) instructions. Below are some Android and iOS specifics that are required for the geolocator to work correctly.
  
<details>
<summary>Android</summary>
  
**Upgrade pre 1.12 Android projects**
  
Since version 5.0.0 this plugin is implemented using the Flutter 1.12 Android plugin APIs. Unfortunately this means App developers also need to migrate their Apps to support the new Android infrastructure. You can do so by following the [Upgrading pre 1.12 Android projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects) migration guide. Failing to do so might result in unexpected behaviour.

**AndroidX** 

The geolocator plugin requires the AndroidX version of the Android Support Libraries. This means you need to make sure your Android project supports AndroidX. Detailed instructions can be found [here](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility). 

The TL;DR version is:

1. Add the following to your "gradle.properties" file:

```
android.useAndroidX=true
android.enableJetifier=true
```
2. Make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file to 30:

```
android {
  compileSdkVersion 30

  ...
}
```
3. Make sure you replace all the `android.` dependencies to their AndroidX counterparts (a full list can be found here: https://developer.android.com/jetpack/androidx/migrate).

**Permissions**

On Android you'll need to add either the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission to your Android Manifest. To do so open the AndroidManifest.xml file (located under android/app/src/main) and add one of the following two lines as direct children of the `<manifest>` tag (when you configure both permissions the `ACCESS_FINE_LOCATION` will be used be the geolocator plugin):

``` xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Starting from Android 10 you need to add the `ACCESS_BACKGROUND_LOCATION` permission (next to the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission) if you want to continue receiving updates even when your App is running in the background (note that the geolocator plugin doesn't support receiving an processing location updates while running in the background):

``` xml
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

> **NOTE:** Specifying the `ACCESS_COARSE_LOCATION` permission results in location updates with an accuracy approximately equivalent to a city block. It might take a long time (minutes) before you will get your first locations fix as `ACCESS_COARSE_LOCATION` will only use the network services to calculate the position of the device. More information can be found [here](https://developer.android.com/training/location/retrieve-current#permissions). 


</details>

<details>
<summary>iOS</summary>

On iOS you'll need to add the following entries to your Info.plist file (located under ios/Runner) in order to access the device's location. Simply open your Info.plist file and add the following:

``` xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
```

If you would like to receive updates when your App is in the background, you'll also need to add the Background Modes capability to your XCode project (Project > Signing and Capabilities > "+ Capability" button) and select Location Updates. Be careful with this, you will need to explain in detail to Apple why your App needs this when submitting your App to the AppStore. If Apple isn't satisfied with the explanation your App will be rejected.

</details>

<details>
<summary>Web</summary>

To use the Geolocator plugin on the web you need to be using Flutter 1.20 or higher. Flutter will automatically add the endorsed [geolocator_web]() package to your application when you add the `geolocator: ^6.2.0` dependency to your `pubspec.yaml`.

Note that the following methods of the geolocator API are not supported on the web and will result in a `PlatformException` with the code `UNSUPPORTED_OPERATION`:

- `getLastKnownPosition({ bool forceAndroidLocationManager = true })`
- `openAppSettings()`
- `openLocationSettings()`

</details>

### Example

The code below shows an example on how to acquire the current position of the device, including checking if the location services are enabled and checking / requesting permission to access the position of the device:

```dart
import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}
```

## API

### Geolocation

To query the current location of the device simply make a call to the `getCurrentPosition` method. You can finetune the results by specifying the following parameters:

- `desiredAccuracy`: the accuracy of the location data that your app wants to receive;
- `timeLimit`: the maximum amount of time allowed to acquire the current location. When the time limit is passed a `TimeOutException` will be thrown and the call will be cancelled. By default no limit is configured.

``` dart
import 'package:geolocator/geolocator.dart';

Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
```

To query the last known location retrieved stored on the device you can use the `getLastKnownPosition` method (note that this can result in a `null` value when no location details are available):

``` dart
import 'package:geolocator/geolocator.dart';

Position position = await Geolocator.getLastKnownPosition();
```

To listen for location changes you can call the `getPositionStream` to receive stream you can listen to and receive position updates. You can finetune the results by specifying the following parameters:

- `desiredAccuracy`: the accuracy of the location data that your app wants to receive;
- `distanceFilter`: the minimum distance (measured in meters) a device must move horizontally before an update event is generated;
- `timeInterval`: (Android only) the minimum amount of time that needs to pass before an update event is generated;
- `timeLimit`: the maximum amount of time allowed between location updates. When the time limit is passed a `TimeOutException` will be thrown and the stream will be cancelled. By default no limit is configured.

``` dart
import 'package:geolocator/geolocator.dart';

StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationOptions).listen(
    (Position position) {
        print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
    });
```

To check if location services are enabled you can call the `isLocationServiceEnabled` method:

``` dart
import 'package:geolocator/geolocator.dart';

bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
```

### Permissions

The geolocator will automatically try to request permissions when you try to acquire a location trough the `getCurrentPosition` or `getPositionStream` methods. We do however provide methods that will allow you to manually handle requesting permissions.

If you want to check if the user already granted permissions to acquire the device's location you can make a call to the `checkPermission` method:

``` dart
import 'package:geolocator/geolocator.dart';

LocationPermission permission = await Geolocator.checkPermission();
```

If you want to request permission to access the device's location you can call the `requestPermission` method:

``` dart
import 'package:geolocator/geolocator.dart';

LocationPermission permission = await Geolocator.requestPermission();
```

Possible results from the `checkPermission` and `requestPermission` methods are:

Permission | Description
-----------|------------
denied | Permission to access the device's location is denied by the user. You are free to request permission again (this is also the initial permission state).
deniedForever | Android only: Permission to access the device's location is denied forever. If requesting permission the permission dialog will NOT been shown until the user updates the permission in the App settings.
whileInUse | Permission to access the device's location is allowed only while the App is in use.
always | Permission to access the device's location is allowed even when the App is running in the background.

### Settings

In some cases it is necessary to ask the user and update their device settings. For example when the user initially permanently denied permissions to access the device's location or if the location services are not enabled (and, on Android, automatic resolution didn't work). In these cases you can use the `openAppSettings` or `openLocationSettings` methods to immediately redirect the user to the device's settings page. 

On Android the `openAppSettings` method will redirect the user to the App specific settings where the user can update necessary permissions. The `openLocationSettings` method will redirect the user to the location settings where the user can enable/ disable the location services.

On iOS we are not allowed to open specific setting pages so both methods will redirect the user to the Settings App from where the user can navigate to the correct settings category to update permissions or enable/ disable the location services.

``` dart
import 'package:geolocator/geolocator.dart';

await Geolocator.openAppSettings();
await Geolocator.openLocationSettings();
```

### Utility methods

To calculate the distance (in meters) between two geocoordinates you can use the `distanceBetween` method. The `distanceBetween` method takes four parameters:

Parameter | Type | Description
----------|------|------------
startLatitude | double | Latitude of the start position
startLongitude | double | Longitude of the start position
endLatitude | double | Latitude of the destination position
endLongitude | double | Longitude of the destination position

``` dart
import 'package:geolocator/geolocator.dart';

double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
```

If you want to calculate the bearing between two geocoordinates you can use the `bearingBetween` method. The `bearingBetween` method also takes four parameters:

Parameter | Type | Description
----------|------|------------
startLatitude | double | Latitude of the start position
startLongitude | double | Longitude of the start position
endLatitude | double | Latitude of the destination position
endLongitude | double | Longitude of the destination position

``` dart
import 'package:geolocator/geolocator.dart';

double bearing = Geolocator.bearingBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
```

### Location accuracy

The table below outlines the accuracy options per platform:

|            | Android    | iOS   |
|------------|-----------:|------:|
| **lowest** | 500m       | 3000m |
| **low**    | 500m       | 1000m |    
| **medium** | 100 - 500m | 100m  |
| **high**   | 0 - 100m   | 10m   |
| **best**   | 0 - 100m   | ~0m   |
| **bestForNavigation** | 0 - 100m | [Optimized for navigation](https://developer.apple.com/documentation/corelocation/kcllocationaccuracybestfornavigation) |

## Issues

Please file any issues, bugs or feature requests as an issue on our [GitHub](https://github.com/Baseflow/flutter-geolocator/issues) page. Commercial support is available, you can contact us at <hello@baseflow.com>.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Baseflow/flutter-geolocator/pulls).

## Author

This Geolocator plugin for Flutter is developed by [Baseflow](https://baseflow.com).
