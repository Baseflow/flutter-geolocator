import 'dart:io';

import 'package:flutter/material.dart';

import 'pages/calculate_distance_widget.dart';
import 'pages/current_location_widget.dart';
import 'pages/location_stream_widget.dart';

void main() => runApp(GeolocatorExampleApp());

enum TabItem { singleLocation, singleFusedLocation, locationStream, distance }

class GeolocatorExampleApp extends StatefulWidget {
  @override
  State<GeolocatorExampleApp> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<GeolocatorExampleApp> {
  TabItem _currentItem = TabItem.singleLocation;

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
      case TabItem.singleLocation:
      default:
        return CurrentLocationWidget(androidFusedLocation: false);
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        _buildBottomNavigationBarItem(
            Icons.location_on, TabItem.singleLocation),
        if (Platform.isAndroid)
          _buildBottomNavigationBarItem(
              Icons.location_on, TabItem.singleFusedLocation),
        _buildBottomNavigationBarItem(Icons.clear_all, TabItem.locationStream),
        _buildBottomNavigationBarItem(Icons.redo, TabItem.distance),
      ],
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
    TabItem selectedTabItem;

    switch (index) {
      case 0:
        selectedTabItem = TabItem.singleLocation;
        break;
      case 1:
        selectedTabItem = Platform.isAndroid
            ? TabItem.singleFusedLocation
            : TabItem.locationStream;
        break;
      case 2:
        selectedTabItem =
            Platform.isAndroid ? TabItem.locationStream : TabItem.distance;
        break;
      default:
        selectedTabItem = TabItem.distance;
    }

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
      default:
        throw 'Unknown: $item';
    }
  }
}
