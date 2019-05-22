import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LookupCoordinatesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LookupCoordinatesState();
}

class _LookupCoordinatesState extends State<LookupCoordinatesWidget> {
  final Geolocator _geolocator = Geolocator();
  final TextEditingController _coordinatesTextController =
      TextEditingController();

  String _placemark = '';

  Future<void> _onLookupAddressPressed() async {
    final List<String> coords = _coordinatesTextController.text.split(',');
    final double latitude = double.parse(coords[0]);
    final double longitude = double.parse(coords[1]);
    final List<Placemark> placemarks =
        await _geolocator.placemarkFromCoordinates(latitude, longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.thoroughfare + ', ' + pos.locality;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          decoration: const InputDecoration(hintText: 'latitude,longitude'),
          controller: _coordinatesTextController,
        ),
        RaisedButton(
          child: const Text('Look up...'),
          onPressed: () {
            _onLookupAddressPressed();
          },
        ),
        Text(_placemark),
      ],
    );
  }
}
