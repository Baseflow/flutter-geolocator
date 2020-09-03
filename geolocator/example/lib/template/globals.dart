import 'dart:core';

import 'package:flutter/material.dart';
import '../plugin_example/last_known_location_example_widget.dart';
import '../plugin_example/position_updates_example_widget.dart';

import 'info_page.dart';

/// Defines the name of the plugin
const String pluginName = 'Geolocator';

/// Defines the URL to the GitHub repository.
const String githubURL = 'https://github.com/Baseflow/flutter-geolocator';

/// Defines the URL to the Baseflow website.
const String baseflowURL = 'https://baseflow.com';

/// Defines the URL to the plugin on Pub.dev
const String pubDevURL = 'https://pub.dev/packages/geolocator';

/// Defines the default horizontal padding
const EdgeInsets defaultHorizontalPadding =
    EdgeInsets.symmetric(horizontal: 24);

/// Defines the detault vertical padding
const EdgeInsets defaultVerticalPadding = EdgeInsets.symmetric(vertical: 24);

/// Defines the icons shown on the bottom tab bar.
final icons = [
  Icons.location_on,
  Icons.map,
  Icons.info_outline,
];

/// Defines the pages linked to the items on the  bottom app bar.
final pages = [
  LastKnownLocationExampleWidget(),
  PositionUpdatesExampleWidget(),
  InfoPage(),
];
