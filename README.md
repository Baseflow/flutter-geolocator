# Flutter geolocator plugin

The Flutter geolocator plugin is build following the federated plugin architecture. A detailed explanation of the federated plugin concept can be found in the [Flutter documentation](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins). This means the geolocator plugin is separated into the following packages:

1. [`geolocator`][1]: the app facing package. This is the package users depend on to use the plugin in their project. For details on how to use the [`geolocator`][1] plugin you can refer to its [README.md][2] file. At this moment the Android and iOS platform implementations are also part of this package;
2. [`geolocator_web`][3]: this package contains the endorsed web implementation of the geolocator_platform_interface. And adds web support to the [`geolocator`][1] app facing package. More information can be found in its [README.md][4] file;
3. [`geolocator_platform_interface`][5]: this packages declares the interface which all platform packages must implement to support the app-facing package. Instructions on how to implement a platform packages can be found int the [README.md][6] of the [`geolocator_platform_interface`][5] package.

[1]: ./geolocator
[2]: ./geolocator/README.md
[3]: ./geolocator_web
[4]: ./geolocator_web/README.md
[5]: ./geolocator_platform_interface
[6]: ./geolocator_platform_interface/README.md
