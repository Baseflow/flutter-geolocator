import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'main.dart';

/// Defines all possible menu options
enum MenuOptions {
  /// The menu option to open the App settings.
  appSettings,

  /// The menu option to open the location settings.
  locationSettings,
}

/// A widget that defines the popup menu shown as action in the
/// App bar.
class SettingsMenu extends StatelessWidget {
  @override
  Widget build(Object context) {
    return PopupMenuButton<MenuOptions>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      color: themeMaterialColor,
      onSelected: (option) => _handleMenuOption(context, option),
      itemBuilder: (context) => <PopupMenuEntry<MenuOptions>>[
        const PopupMenuItem(
          value: MenuOptions.appSettings,
          child: Text('Open App Settings'),
        ),
        const PopupMenuItem(
          value: MenuOptions.locationSettings,
          child: Text('Open Location Settings'),
        ),
      ],
    );
  }

  void _handleMenuOption(BuildContext context, MenuOptions option) {
    switch (option) {
      case MenuOptions.appSettings:
       Geolocator.openAppSettings();
        break;
      case MenuOptions.locationSettings:
       Geolocator.openLocationSettings();
        break;
    }
  }
}
