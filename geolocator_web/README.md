# geolocator_web

[![pub package](https://img.shields.io/pub/v/geolocator.svg)](https://pub.dartlang.org/packages/geolocator) ![Build status](https://github.com/Baseflow/flutter-geolocator/workflows/geolocator_web/badge.svg?branch=master) [![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)

The official web implementation of the [geolocator](https://pub.dev/packages/geolocator) plugin by [Baseflow](https://baseflow.com).

## Usage

Since version 6.2.0 of the [geolocator](https://pub.dev/packages/geolocator) plugin this is the endorsed web implementation. This means it will automatically be added to your dependencies when you depend on `geolocator: ^6.2.0` in your applications pubspec.yaml.

More detailed instructions on using the API can be found in the [README.md](../geolocator/README.md) of the [geolocator](https://pub.dev/packages/geolocator) package.

## Issues

Please file any issues, bugs or feature requests as an issue on our [GitHub](https://github.com/Baseflow/flutter-geolocator/issues) page. Commercial support is available, you can contact us at <hello@baseflow.com>.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Baseflow/flutter-geolocator/pulls).

## Tests

Tests require being run on a browser due to the use of the `dart:js_interop` package:

`flutter test --platform chrome`

## Author

This Geolocator plugin for Flutter is developed by [Baseflow](https://baseflow.com).
