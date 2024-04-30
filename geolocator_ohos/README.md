# geolocator_ohos


The OpenHarmony implementation of [`geolocator`][1].

[`geolocator`][1] 在 OpenHarmony 平台的实现。


# 使用

```yaml
dependencies:
  geolocator: any
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

