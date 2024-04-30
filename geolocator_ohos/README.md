# geolocator_ohos


The OpenHarmony implementation of [`geolocator`][1].

[`geolocator`][1] 在 OpenHarmony 平台的实现。


# Usage

```yaml
dependencies:
  geolocator: any
  geolocator_ohos: any
```

在你的项目的 `module.json5` 文件中增加以下权限设置。

```json
    "requestPermissions": [
      {"name" :  "ohos.permission.KEEP_BACKGROUND_RUNNING"},
      {
        "name": "ohos.permission.LOCATION",
        "reason": "$string:EntryAbility_label",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.APPROXIMATELY_LOCATION",
        "reason": "$string:EntryAbility_label",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.LOCATION_IN_BACKGROUND",
        "reason": "$string:EntryAbility_label",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      },                  
    ]
```


 [1]: https://pub.dev/packages/geolocator

## OpenHarmony only

### Common

``` dart
CountryCode? countryCode= await geolocatorOhos.getCountryCode();
```

### Geocoder

``` dart
    final position = await geolocatorOhos.getCurrentPosition(
      locationSettings: const CurrentLocationSettingsOhos(
        priority: LocationRequestPriority.firstFix,
        scenario: LocationRequestScenario.unset,
      ),
    );

    // ohos only
    if (await geolocatorOhos.isGeocoderAvailable()) {
      // 
      var addresses = await geolocatorOhos.getAddressesFromLocation(
        ReverseGeoCodeRequest(
          latitude: position.latitude,
          longitude: position.longitude,
          locale: 'zh',
          maxItems: 1,
        ),
      );

      for (var address in addresses) {
        if (kDebugMode) {
          print('ReverseGeoCode address:$address');
        }
        var position = await geolocatorOhos.getAddressesFromLocationName(
          GeoCodeRequest(description: address.placeName ?? ''),
        );
        if (kDebugMode) {
          print('geoCode position:$position');
        }
      }
    }
```