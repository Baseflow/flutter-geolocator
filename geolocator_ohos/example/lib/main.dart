import 'dart:async';
import 'dart:io' show Platform;

import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_utils/flutter_platform_utils.dart';
import 'package:geolocator_ohos/geolocator_ohos.dart';

/// Defines the main theme color.
final MaterialColor themeMaterialColor =
    BaseflowPluginExample.createMaterialColor(
        const Color.fromRGBO(48, 49, 60, 1));

void main() {
  runApp(const GeolocatorWidget());
}

/// Example [Widget] showing the functionalities of the geolocator plugin.
class GeolocatorWidget extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const GeolocatorWidget({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.
  static ExamplePage createPage() {
    return ExamplePage(
        Icons.location_on, (context) => const GeolocatorWidget());
  }

  @override
  State<GeolocatorWidget> createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorOhos geolocatorOhos =
      GeolocatorPlatform.instance as GeolocatorOhos;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;

  @override
  void initState() {
    super.initState();
    _toggleServiceStatusStream();
  }

  PopupMenuButton _createActions() {
    return PopupMenuButton(
      elevation: 40,
      onSelected: (value) async {
        switch (value) {
          case 1:
            _getLocationAccuracy();
            break;
          case 2:
            _requestTemporaryFullAccuracy();
            break;
          case 3:
            _openAppSettings();
            break;
          case 4:
            _openLocationSettings();
            break;
          case 5:
            setState(_positionItems.clear);
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("Get Location Accuracy"),
        ),
        if (Platform.isIOS)
          const PopupMenuItem(
            value: 2,
            child: Text("Request Temporary Full Accuracy"),
          ),
        const PopupMenuItem(
          value: 3,
          child: Text("Open App Settings"),
        ),
        if (Platform.isAndroid || PlatformUtils.isOhos)
          const PopupMenuItem(
            value: 4,
            child: Text("Open Location Settings"),
          ),
        const PopupMenuItem(
          value: 5,
          child: Text("Clear"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );

    return BaseflowPluginExample(
        pluginName: 'Geolocator',
        githubURL: 'https://github.com/Baseflow/flutter-geolocator',
        pubDevURL: 'https://pub.dev/packages/geolocator',
        appBarActions: [
          _createActions()
        ],
        pages: [
          ExamplePage(
            Icons.location_on,
            (context) => Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: ListView.builder(
                itemCount: _positionItems.length,
                itemBuilder: (context, index) {
                  final positionItem = _positionItems[index];

                  if (positionItem.type == _PositionItemType.log) {
                    return ListTile(
                      title: Text(positionItem.displayValue,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    );
                  } else {
                    return Card(
                      child: ListTile(
                        tileColor: themeMaterialColor,
                        title: Text(
                          positionItem.displayValue,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
              ),
              floatingActionButton: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: _toggleListening,
                    tooltip: (_positionStreamSubscription == null)
                        ? 'Start position updates'
                        : _positionStreamSubscription!.isPaused
                            ? 'Resume'
                            : 'Pause',
                    backgroundColor: _determineButtonColor(),
                    child: (_positionStreamSubscription == null ||
                            _positionStreamSubscription!.isPaused)
                        ? const Icon(Icons.play_arrow)
                        : const Icon(Icons.pause),
                  ),
                  sizedBox,
                  FloatingActionButton(
                    onPressed: _getCurrentPosition,
                    child: const Icon(Icons.my_location),
                  ),
                  sizedBox,
                  FloatingActionButton(
                    onPressed: _getLastKnownPosition,
                    child: const Icon(Icons.bookmark),
                  ),
                ],
              ),
            ),
          )
        ]);
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await geolocatorOhos.getCurrentPosition(
      locationSettings: const CurrentLocationSettingsOhos(
        priority: LocationRequestPriority.firstFix,
        scenario: LocationRequestScenario.unset,
      ),
    );

    CountryCode? countryCode = await geolocatorOhos.getCountryCode();
    if (kDebugMode) {
      print('CountryCode: $countryCode\n');
    }

    // ohos only
    if (await geolocatorOhos.isGeocoderAvailable()) {
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
          print('ReverseGeoCode address:$address\n');
        }
        var position = await geolocatorOhos.getAddressesFromLocationName(
          GeoCodeRequest(description: address.placeName ?? ''),
        );
        if (kDebugMode) {
          print('geoCode position:$position\n');
        }
      }
    }
    _updatePositionList(
      _PositionItemType.position,
      position.toString(),
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocatorOhos.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await geolocatorOhos.checkPermission(
      permissions: GeolocatorOhos.accuracyPermissions,
    );
    if (permission == LocationPermission.denied) {
      permission = await geolocatorOhos.requestPermission(
        permissions: GeolocatorOhos.accuracyPermissions,
      );
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = geolocatorOhos.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          serviceStatusValue = 'enabled';
        } else {
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(
          _PositionItemType.log,
          'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  Future<void> _toggleListening() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    if (_positionStreamSubscription == null) {
      const ohosSettings = LocationSettingsOhos(
        priority: LocationRequestPriority.firstFix,
        scenario: LocationRequestScenario.unset,
        timeInterval: 1,
        distanceInterval: 0,
        maxAccuracy: 0,
      );
      final positionStream = geolocatorOhos.getPositionStream(
        locationSettings: ohosSettings,
      );
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) {
        debugPrint(position.altitude.toString());
        _updatePositionList(
          _PositionItemType.position,
          position.toString(),
        );
      });
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  void _getLastKnownPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await geolocatorOhos.getLastKnownPosition();
    if (position != null) {
      _updatePositionList(
        _PositionItemType.position,
        position.toString(),
      );
    } else {
      _updatePositionList(
        _PositionItemType.log,
        'No last known position available',
      );
    }
  }

  void _getLocationAccuracy() async {
    final status = await geolocatorOhos.getLocationAccuracy();
    _handleLocationAccuracyStatus(status);
  }

  void _requestTemporaryFullAccuracy() async {
    final status = await geolocatorOhos.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }
    _updatePositionList(
      _PositionItemType.log,
      '$locationAccuracyStatusValue location accuracy granted.',
    );
  }

  void _openAppSettings() async {
    final opened = await geolocatorOhos.openAppSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Application Settings.';
    } else {
      displayValue = 'Error opening Application Settings.';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }

  void _openLocationSettings() async {
    final opened = await geolocatorOhos.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
    } else {
      displayValue = 'Error opening Location Settings';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
