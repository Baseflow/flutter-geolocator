import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CalculateDistanceWidget extends StatefulWidget {
  @override
  _CalculateDistanceState createState() => _CalculateDistanceState();
}

class _CalculateDistanceState extends State<CalculateDistanceWidget> {
  final Geolocator _geolocator = Geolocator();
  final TextEditingController _startCoordinatesTextController = TextEditingController();
  final TextEditingController _endCoordinatesTextController = TextEditingController();
  
  String _distance = '';
  
  void _onCalculatePressed() async {
    var startCoords = _startCoordinatesTextController.text.split(',');
    var endCoords = _endCoordinatesTextController.text.split(',');
    var startLatitude = double.parse(startCoords[0]);
    var startLongitude = double.parse(startCoords[1]);
    var endLatitude = double.parse(endCoords[0]);
    var endLongitude = double.parse(endCoords[1]);

    double distance =
        await _geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);

    setState(() {
      _distance = 'The distance is: $distance';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
                  new TextField(
                    decoration:
                        new InputDecoration(hintText: "start latitude,start longitude"),
                    controller: _startCoordinatesTextController,
                  ),
                  new TextField(
                    decoration:
                        new InputDecoration(hintText: "end latitude,end longitude"),
                    controller: _endCoordinatesTextController,
                  ),
                  new RaisedButton(
                    child: new Text('Calculate...'),
                    onPressed: () {
                      _onCalculatePressed();
                    },
                  ),
                  new Text(_distance),
      ],
    );
  }
}