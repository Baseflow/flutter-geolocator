## 0.2.2

* Fixes crash under Windows when getCurrentPosition method is called. (#1240)

## 0.2.1

* Exposes altitude accuracy to the `Position` class.

## 0.2.0

* **BREAKING CHANGE:** Synchronizes the default values of `Position.altitude`, `Position.heading` and `Position.speed` with the other platforms and return 0.0 if the value is not known.
* Migrates the `target_compile_options` to use `/await:strict` to make the options compatible with C++ 20.

## 0.1.3

* Adds a `PositionStatus::Initializing` status consideration since it triggers the state change 
if "Let apps access your location" toggle option is switched ON from OFF.

## 0.1.2

* Adds improved Flutter analysis and resolved warnings.
* Updates dependencies to current versions.
* Fixes plugin registration in `dart_plugin_registrant.dart`.

## 0.1.1

* Fixes repository URL of the package.

## 0.1.0

* Adds an initial implementation of Windows support for the geolocator plugin.
