import 'dart:core';

import 'package:flutter/material.dart';
import 'package:geolocator_example/plugin_example/last_known_location_example_widget.dart';
import 'package:geolocator_example/plugin_example/position_updates_example_widget.dart';

import 'info_page.dart';

class Globals {
  static const String pluginName = 'Geocoding';
  static const String githubURL =
      'https://github.com/Baseflow/flutter-geolocator';
  static const String baseflowURL = 'https://baseflow.com';
  static const String pubDevURL = 'https://pub.dev/packages/geolocator';

  static const EdgeInsets defaultHorizontalPadding =
      EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets defaultVerticalPadding =
      EdgeInsets.symmetric(vertical: 24);

  static final icons = [
    Icons.location_on,
    Icons.map,
    Icons.info_outline,
  ];

  static final pages = [
    LastKnownLocationExampleWidget(),
    PositionUpdatesExampleWidget(),
    InfoPage(),
  ];
}
