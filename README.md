# Flutter Geolocator Plugin  

[![pub package](https://img.shields.io/pub/v/geolocator.svg)](https://pub.dartlang.org/packages/geolocator) [![Build Status](https://app.bitrise.io/app/b0e244f2c82e1678/status.svg?token=x6sBRHLW05ymIpW-dVJlgQ&branch=master)](https://app.bitrise.io/app/b0e244f2c82e1678) [![codecov](https://codecov.io/gh/Baseflow/flutter-geolocator/branch/master/graph/badge.svg)](https://codecov.io/gh/Baseflow/flutter-geolocator)

A Flutter geolocation plugin which provides easy access to the platform specific location services ([FusedLocationProviderClient](https://developers.google.com/android/reference/com/google/android/gms/location/FusedLocationProviderClient) or if not available the [LocationManager](https://developer.android.com/reference/android/location/LocationManager) on Android and [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager) on iOS).


## Features

* Get the current location of the device;
* Get the last known location;
* Get continuous location updates;
* Check if location services are enabled on the device;
* Translate an address to geocoordinates and vice verse (a.k.a. Geocoding);
* Calculate the distance (in meters) between two geocoordinates;
* Check the availability of Google Play services (on Android only).

**Note**: The availability of the Google Play Services depends on your country. If your country doesn't support a connection with the Google Play Services, you need to try a VPN to establish a connection. For more information about how to work with Google Play Services visit the following link: https://developers.google.com/android/guides/overview 

## Usage

To use this plugin, add `geolocator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  geolocator: ^5.3.1
```

Paul Halliday wrote a nice introductory article on [getting the user's location using the Geolocator plugin](https://alligator.io/flutter/geolocator-plugin/). If you are new to the plugin this would be a great place to get started. 

> **NOTE:** As of version 3.0.0 the geolocator plugin switched to the AndroidX version of the Android Support Libraries. This means you need to make sure your Android project is also upgraded to support AndroidX. Detailed instructions can be found [here](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility). 
>
>The TL;DR version is:
>
>1. Add the following to your "gradle.properties" file:
>
>```
>android.useAndroidX=true
>android.enableJetifier=true
>```
>2. Make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file to 28:
>
>```
>android {
>  compileSdkVersion 28
>
>  ...
>}
>```
>3. Make sure you replace all the `android.` dependencies to their AndroidX counterparts (a full list can be found here: https://developer.android.com/jetpack/androidx/migrate).

## API

### Geolocation

To query the current location of the device simply make a call to the `getCurrentPosition` method:

``` dart
import 'package:geolocator/geolocator.dart';

Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
```

To query the last known location retrieved stored on the device you can use the `getLastKnownPosition` method (note that this can result in a `null` value when no location details are available):

``` dart
import 'package:geolocator/geolocator.dart';

Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
```

To listen for location changes you can subscribe to the `onPositionChanged` stream. Supply an instance of the `LocationOptions` class to configure
the desired accuracy and the minimum distance change (in meters) before updates are send to the application.

``` dart
import 'package:geolocator/geolocator.dart';

var geolocator = Geolocator();
var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
    (Position position) {
        print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
    });
```

To check if location services are enabled you can call the `checkGeolocationPermissionStatus` method. This method returns a value of the `GeolocationStatus` enum indicating the availability of the location services on the device. Optionally you can specify if you want to test for `GeolocationPermission.locationAlways` or `GeolocationPermission.locationWhenInUse` (by default `GeolocationPermission.location` is used, which checks for either one of the previously mentioned permissions). Example usage:

``` dart
import 'package:geolocator/geolocator.dart';

GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
```

By default `Geolocator` will use `FusedLocationProviderClient` on Android when Google Play Services are available. It will fall back to `LocationManager` when it is not available. You can override the behaviour by setting `forceAndroidLocationManager`.

``` dart
import 'package:geolocator/geolocator.dart';

Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
GeolocationStatus geolocationStatus  = await geolocator.checkGeolocationPermissionStatus();
```

To check if location services are enabled(Location Service(GPS) turned on) on the device `checkGeolocationPermissionStatus` will return `disabled` state if location service feature is disabled (or not available) on the device.

### Geocoding

To translate an address into latitude and longitude coordinates you can use the `placemarkFromAddress` method:

``` dart
import 'package:geolocator/geolocator.dart';

List<Placemark> placemark = await Geolocator().placemarkFromAddress("Gronausestraat 710, Enschede");
```

If you want to translate latitude and longitude coordinates into an address you can use the `placemarkFromCoordinates` method:

``` dart
import 'package:geolocator/geolocator.dart';

List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(52.2165157, 6.9437819);
```

Both the `placemarkFromAddress` and `placemarkFromCoordinates` accept an optional `localeIdentifier` parameter. This paramter can be used to enforce the resulting placemark to be formatted (and translated) according to the specified locale. The `localeIdentifier` should be formatted using the syntax: [languageCode]_[countryCode]. Use the [ISO 639-1 or ISO 639-2](http://www.loc.gov/standards/iso639-2/php/English_list.php) standard for the language code and the 2 letter [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) standard for the country code. Some examples are:

Locale identifier | Description
----------------- | -----------
en | All English speakers (will translate all attributes to English)
en_US | English speakers in the United States of America
en_UK | English speakers in the United Kingdom
nl_NL | Dutch speakers in The Netherlands
nl_BE | Dutch speakers in Belgium

### Calculate distance

To calculate the distance (in meters) between two geocoordinates you can use the `distanceBetween` method. The `distanceBetween` method takes four parameters:

Parameter | Type | Description
----------|------|------------
startLatitude | double | Latitude of the start position
startLongitude | double | Longitude of the start position
endLatitude | double | Latitude of the destination position
endLongitude | double | Longitude of the destination position

``` dart
import 'package:geolocator/geolocator.dart';

double distanceInMeters = await Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
```

See also the [example](example/lib/main.dart) project for a complete implementation.

## Permissions

### Android

On Android you'll need to add either the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission to your Android Manifest. To do so open the AndroidManifest.xml file (located under android/app/src/main) and add one of the following two lines as direct children of the `<manifest>` tag:

``` xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

> **NOTE:** Specifying the `ACCESS_COARSE_LOCATION` permission results in location updates with an accuracy approximately equivalant to a city block. More information can be found [here](https://developer.android.com/training/location/retrieve-current#permissions).

### iOS

On iOS you'll need to add the `NSLocationWhenInUseUsageDescription` to your Info.plist file (located under ios/Runner/Base.lproj) in order to access the device's location. Simply open your Info.plist file and add the following:

``` xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
```

If you would like to access the device's location when your App is running in the background, you should also add the `NSLocationAlwaysAndWhenInUseUsageDescription` (if your App support iOS 10 or earlier you should also add the key `NSLocationAlwaysUsageDescription`) key to your Info.plist file:

``` xml
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to location when open and in the background.</string>
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

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/BaseflowIT/flutter-geolocator/issues) page.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](CONTRIBUTING.md) and send us your [pull request](https://github.com/BaseflowIT/flutter-geolocator/pulls).

## Author

This Geolocator plugin for Flutter is developed by [Baseflow](https://baseflow.com). You can contact us at <hello@baseflow.com>
