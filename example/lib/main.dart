import 'dart:io';

import 'package:flutter/material.dart';

import 'pages/lookup_address_widget.dart';
import 'pages/calculate_distance_widget.dart';
import 'pages/current_location_widget.dart';
import 'pages/location_stream_widget.dart';

void main() => runApp(_GeolocatorExampleApp());
  enum _TabItem {
    singleLocation,
    singleFusedLocation,
    locationStream,
    distance,
    geocode
  }

class _GeolocatorExampleApp extends StatefulWidget {
  @override
  State<_GeolocatorExampleApp> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<_GeolocatorExampleApp> {


  _TabItem _currentItem = _TabItem.singleLocation;
  final List<_TabItem> _bottomTabs = [
    _TabItem.singleLocation,
    _TabItem.locationStream,
    _TabItem.distance,
    _TabItem.geocode,
  ];

  @override
  void initState() {
    if (Platform.isAndroid) {
      _bottomTabs.insert(1, _TabItem.singleFusedLocation);
    } 
    super.initState();
  }
  
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
      case _TabItem.locationStream:
        return LocationStreamWidget();
      case _TabItem.distance:
        return CalculateDistanceWidget();
      case _TabItem.singleFusedLocation:
        return CurrentLocationWidget(androidFusedLocation: true);
      case _TabItem.geocode:
        return LookupAddressWidget();
      case _TabItem.singleLocation:
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
      IconData icon, _TabItem tabItem) {
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
    _TabItem selectedTabItem = _bottomTabs[index];

    setState(() {
      _currentItem = selectedTabItem;
    });
  }

  String _title(_TabItem item) {
    switch (item) {
      case _TabItem.singleLocation:
        return 'Single';
      case _TabItem.singleFusedLocation:
        return 'Single (Fused)';
      case _TabItem.locationStream:
        return 'Stream';
      case _TabItem.distance:
        return 'Distance';
      case _TabItem.geocode:
        return 'Geocode';
      default:
        throw 'Unknown: $item';
    }
  }

  IconData _icon(_TabItem item) {
    switch (item) {
      case _TabItem.singleLocation:
        return Icons.location_on;
      case _TabItem.singleFusedLocation:
        return Icons.location_on;
      case _TabItem.locationStream:
        return Icons.clear_all;
      case _TabItem.distance:
        return Icons.redo;
      case _TabItem.geocode:
        return Icons.compare_arrows;
      default:
        throw 'Unknown: $item';
    }
  }
}
