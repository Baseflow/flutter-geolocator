import 'dart:core';

import 'package:flutter/material.dart';
import 'package:geolocator_example/plugin_example/last_known_location_example_widget.dart';
import 'package:geolocator_example/plugin_example/position_updates_example_widget.dart';

import 'info_page.dart';

/// Class that defines global configuration variables
class Globals {
  /// Defines the name of the plugin
  static const String pluginName = 'Geolocator';
  /// Defines the URL to the GitHub repository.
  static const String githubURL =
      'https://github.com/Baseflow/flutter-geolocator';
  /// Defines the URL to the Baseflow website.
  static const String baseflowURL = 'https://baseflow.com';
  /// Defines the URL to the plugin on Pub.dev
  static const String pubDevURL = 'https://pub.dev/packages/geolocator';
  /// Defines the default horizontal padding
  static const EdgeInsets defaultHorizontalPadding =
      EdgeInsets.symmetric(horizontal: 24);
  /// Defines the detault vertical padding
  static const EdgeInsets defaultVerticalPadding =
      EdgeInsets.symmetric(vertical: 24);

  /// Defines the icons shown on the bottom tab bar.
  static final icons = [
    Icons.location_on,
    Icons.map,
    Icons.info_outline,
  ];

  /// Defines the pages linked to the items on the  bottom app bar.
  static final pages = [
    LastKnownLocationExampleWidget(),
    PositionUpdatesExampleWidget(),
    InfoPage(),
  ];
}
