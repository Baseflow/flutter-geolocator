import 'dart:io';

import 'package:flutter/material.dart';

import 'pages/lookup_address_widget.dart';
import 'pages/calculate_distance_widget.dart';
import 'pages/current_location_widget.dart';
import 'pages/location_stream_widget.dart';

void main() => runApp(GeolocatorExampleApp());

enum TabItem {
  singleLocation,
  singleFusedLocation,
  locationStream,
  distance,
  geocode
}

class GeolocatorExampleApp extends StatefulWidget {
  @override
  State<GeolocatorExampleApp> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<GeolocatorExampleApp> {
  TabItem _currentItem = TabItem.singleLocation;
  final List<TabItem> _bottomTabs = [
    TabItem.singleLocation,
    if (Platform.isAndroid) TabItem.singleFusedLocation,
    TabItem.locationStream,
    TabItem.distance,
    TabItem.geocode,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Geolocator Example App'),
        ),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentItem) {
      case TabItem.locationStream:
        return LocationStreamWidget();
      case TabItem.distance:
        return CalculateDistanceWidget();
      case TabItem.singleFusedLocation:
        return CurrentLocationWidget(androidFusedLocation: true);
      case TabItem.geocode:
        return LookupAddressWidget();
      case TabItem.singleLocation:
      default:
        return CurrentLocationWidget(androidFusedLocation: false);
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: _bottomTabs
          .map((tabItem) =>
              _buildBottomNavigationBarItem(_icon(tabItem), tabItem))
          .toList(),
      onTap: _onSelectTab,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, TabItem tabItem) {
    final String text = _title(tabItem);
    final Color color =
        _currentItem == tabItem ? Theme.of(context).primaryColor : Colors.grey;

    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  void _onSelectTab(int index) {
    TabItem selectedTabItem = _bottomTabs[index];

    setState(() {
      _currentItem = selectedTabItem;
    });
  }

  String _title(TabItem item) {
    switch (item) {
      case TabItem.singleLocation:
        return 'Single';
      case TabItem.singleFusedLocation:
        return 'Single (Fused)';
      case TabItem.locationStream:
        return 'Stream';
      case TabItem.distance:
        return 'Distance';
      case TabItem.geocode:
        return 'Geocode';
      default:
        throw 'Unknown: $item';
    }
  }

  IconData _icon(TabItem item) {
    switch (item) {
      case TabItem.singleLocation:
        return Icons.location_on;
      case TabItem.singleFusedLocation:
        return Icons.location_on;
      case TabItem.locationStream:
        return Icons.clear_all;
      case TabItem.distance:
        return Icons.redo;
      case TabItem.geocode:
        return Icons.compare_arrows;
      default:
        throw 'Unknown: $item';
    }
  }
}
