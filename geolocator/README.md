# Flutter Geolocator Plugin  

[![pub package](https://img.shields.io/pub/v/geolocator.svg)](https://pub.dartlang.org/packages/geolocator) ![Build status](https://github.com/Baseflow/flutter-geolocator/workflows/geolocator/badge.svg?branch=master) [![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart) [![codecov](https://codecov.io/gh/Baseflow/flutter-geolocator/branch/master/graph/badge.svg)](https://codecov.io/gh/Baseflow/flutter-geolocator)

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
> Version 7.0.0 of the geolocator plugin contains several breaking changes, for a complete overview please have a look at the [Breaking changes in 7.0.0](https://github.com/Baseflow/flutter-geolocator/wiki/Breaking-changes-in-7.0.0) wiki page.
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
2. Make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file to 33:

```
android {
  compileSdkVersion 33

  ...
}
```
3. Make sure you replace all the `android.` dependencies to their AndroidX counterparts (a full list can be found here: [Migrating to AndroidX](https://developer.android.com/jetpack/androidx/migrate)).

**Permissions**

On Android you'll need to add either the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission to your Android Manifest. To do so open the AndroidManifest.xml file (located under android/app/src/main) and add one of the following two lines as direct children of the `<manifest>` tag (when you configure both permissions the `ACCESS_FINE_LOCATION` will be used by the geolocator plugin):

``` xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Starting from Android 10 you need to add the `ACCESS_BACKGROUND_LOCATION` permission (next to the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission) if you want to continue receiving updates even when your App is running in the background (note that the geolocator plugin doesn't support receiving and processing location updates while running in the background):

``` xml
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

> **NOTE:** Specifying the `ACCESS_COARSE_LOCATION` permission results in location updates with an accuracy approximately equivalent to a city block. It might take a long time (minutes) before you will get your first locations fix as `ACCESS_COARSE_LOCATION` will only use the network services to calculate the position of the device. More information can be found [here](https://developer.android.com/training/location/retrieve-current#permissions). 


</details>

<details>
<summary>iOS</summary>

On iOS you'll need to add the following entries to your Info.plist file (located under ios/Runner) in order to access the device's location. Simply open your Info.plist file and add the following (make sure you update the description so it is meaningfull in the context of your App):

``` xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
```

If you would like to receive updates when your App is in the background, you'll also need to add the Background Modes capability to your XCode project (Project > Signing and Capabilities > "+ Capability" button) and select Location Updates. Be careful with this, you will need to explain in detail to Apple why your App needs this when submitting your App to the AppStore. If Apple isn't satisfied with the explanation your App will be rejected.

When using the `requestTemporaryFullAccuracy({purposeKey: "YourPurposeKey"})` method, a dictionary should be added to the Info.plist file.
```xml
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
  <key>YourPurposeKey</key>
  <string>The example App requires temporary access to the device&apos;s precise location.</string>
</dict>
```
The second key (in this example called `YourPurposeKey`) should match the purposeKey that is passed in the `requestTemporaryFullAccuracy()` method. It is possible to define multiple keys for different features in your app. More information can be found in Apple's [documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationtemporaryusagedescriptiondictionary).

> NOTE: the first time requesting temporary full accuracy access it might take several seconds for the pop-up to show. This is due to the fact that iOS is determining the exact user location which may take several seconds. Unfortunately this is out of our hands.
</details>

<details>
<summary>macOS</summary>

On macOS you'll need to add the following entries to your Info.plist file (located under macOS/Runner) in order to access the device's location. Simply open your Info.plist file and add the following (make sure you update the description so it is meaningfull in the context of your App):

``` xml
<key>NSLocationUsageDescription</key>
<string>This app needs access to location.</string>
```

You will also have to add the following entry to the DebugProfile.entitlements and Release.entitlements files. This will declare that your App wants to make use of the device's location services and adds it to the list in the "System Preferences" -> "Security & Privace" -> "Privacy" settings.
```xml
<key>com.apple.security.personal-information.location</key>
<true/>
```

When using the `requestTemporaryFullAccuracy({purposeKey: "YourPurposeKey"})` method, a dictionary should be added to the Info.plist file.
```xml
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
  <key>YourPurposeKey</key>
  <string>The example App requires temporary access to the device&apos;s precise location.</string>
</dict>
```
The second key (in this example called `YourPurposeKey`) should match the purposeKey that is passed in the `requestTemporaryFullAccuracy()` method. It is possible to define multiple keys for different features in your app. More information can be found in Apple's [documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationtemporaryusagedescriptiondictionary).

> NOTE: the first time requesting temporary full accuracy access it might take several seconds for the pop-up to show. This is due to the fact that macOS is determining the exact user location which may take several seconds. Unfortunately this is out of our hands.
</details>

<details>
<summary>Web</summary>

To use the Geolocator plugin on the web you need to be using Flutter 1.20 or higher. Flutter will automatically add the endorsed [geolocator_web]() package to your application when you add the `geolocator: ^6.2.0` dependency to your `pubspec.yaml`.

The following methods of the geolocator API are not supported on the web and will result in a `PlatformException` with the code `UNSUPPORTED_OPERATION`:

- `getLastKnownPosition({ bool forceAndroidLocationManager = true })`
- `openAppSettings()`
- `openLocationSettings()`

**NOTE**

Geolocator Web is available only in [secure_contexts](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts) (HTTPS). More info about the Geolocator API can be found [here](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API).

</details>

<details>
<summary>Windows</summary>

To use the Geolocator plugin on Windows you need to be using Flutter 2.10 or higher. Flutter will automatically add the endorsed [geolocator_windows]() package to your application when you add the `geolocator: ^8.1.0` dependency to your `pubspec.yaml`.

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

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
```

## API

### Geolocation

#### Current location

To query the current location of the device simply make a call to the `getCurrentPosition` method. You can finetune the results by specifying the following parameters:

- `desiredAccuracy`: the accuracy of the location data that your app wants to receive;
- `timeLimit`: the maximum amount of time allowed to acquire the current location. When the time limit is passed a `TimeOutException` will be thrown and the call will be cancelled. By default no limit is configured.

``` dart
import 'package:geolocator/geolocator.dart';

Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
```

#### Last known location

To query the last known location retrieved stored on the device you can use the `getLastKnownPosition` method (note that this can result in a `null` value when no location details are available):

``` dart
import 'package:geolocator/geolocator.dart';

Position? position = await Geolocator.getLastKnownPosition();
```

#### Listen to location updates

To listen for location changes you can call the `getPositionStream` to receive stream you can listen to and receive position updates. You can finetune the results by specifying the following parameters:

- `accuracy`: the accuracy of the location data that your app wants to receive;
- `distanceFilter`: the minimum distance (measured in meters) a device must move horizontally before an update event is generated;
- `timeLimit`: the maximum amount of time allowed between location updates. When the time limit is passed a `TimeOutException` will be thrown and the stream will be cancelled. By default no limit is configured.

``` dart
import 'package:geolocator/geolocator.dart';

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);
StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    (Position? position) {
        print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
```

In certain situation it is necessary to specify some platform specific settings. This can be accomplished using the platform specific `AndroidSettings` or `AppleSettings` classes. When using a platform specific class, the platform specific package must be imported as well. For example:

```dart
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';

late LocationSettings locationSettings;

if (defaultTargetPlatform == TargetPlatform.android) {
  locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
    forceLocationManager: true,
    intervalDuration: const Duration(seconds: 10),
    //(Optional) Set foreground notification config to keep the app alive 
    //when going to the background
    foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
        "Example app will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
    )
  );
} else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
  locationSettings = AppleSettings(
    accuracy: LocationAccuracy.high,
    activityType: ActivityType.fitness,
    distanceFilter: 100,
    pauseLocationUpdatesAutomatically: true,
    // Only set to true if our app will be started up in the background.
    showBackgroundLocationIndicator: false,
  );
} else {
    locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
}

StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    (Position? position) {
        print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
```

#### Location accuracy (Android and iOS 14+ only)

To query if a user enabled Approximate location fetching or Precise location fetching, you can call the `Geolocator().getLocationAccuracy()` method. This will return a `Future<LocationAccuracyStatus>`, which when completed contains a `LocationAccuracyStatus.reduced` if the user has enabled Approximate location fetching or `LocationAccuracyStatus.precise` if the user has enabled Precise location fetching.
When calling `getLocationAccuracy` before the user has given permission, the method will return `LocationAccuracyStatus.reduced` by default.
On iOS 13 or below, the method `getLocationAccuracy` will always return `LocationAccuracyStatus.precise`, since that is the default value for iOS 13 and below.

``` dart
import 'package:geolocator/geolocator.dart';

var accuracy = await Geolocator.getLocationAccuracy();
```

#### Location service information

To check if location services are enabled you can call the `isLocationServiceEnabled` method:

``` dart
import 'package:geolocator/geolocator.dart';

bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
```

To listen for service status changes you can call the `getServiceStatusStream`. This will return a `Stream<ServiceStatus>` which can be listened to, to receive location service status updates.

``` dart
import 'package:geolocator/geolocator.dart';

StreamSubscription<ServiceStatus> serviceStatusStream = Geolocator.getServiceStatusStream().listen(
    (ServiceStatus status) {
        print(status);
    });
```

### Permissions

When using the web platform, the `checkPermission` method will return the `LocationPermission.denied` status, when the browser doesn't support the JavaScript Permissions API. Nevertheless, the `getCurrentPosition` and `getPositionStream` methods can still be used on the web platform.

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
deniedForever | Permission to access the device's location is permanently denied. When requesting permissions the permission dialog will not be shown until the user updates the permission in the App settings.
whileInUse | Permission to access the device's location is allowed only while the App is in use.
always | Permission to access the device's location is allowed even when the App is running in the background.

> Note: Android can only return `whileInUse`, `always` or `denied` when checking permissions. Due to limitations on the Android OS it is not possible to determine if permissions are denied permanently when checking permissions. Using a workaround the geolocator is only able to do so as a result of the `requestPermission` method. More information can be found in our [wiki](https://github.com/Baseflow/flutter-geolocator/wiki/Breaking-changes-in-7.0.0#android-permission-update).

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
