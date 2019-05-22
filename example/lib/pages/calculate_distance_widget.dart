import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CalculateDistanceWidget extends StatefulWidget {
  @override
  _CalculateDistanceState createState() => _CalculateDistanceState();
}

class _CalculateDistanceState extends State<CalculateDistanceWidget> {
  final TextEditingController _startCoordinatesTextController =
      TextEditingController();
  final TextEditingController _endCoordinatesTextController =
      TextEditingController();

  Future<void> _onCalculatePressed() async {
    final List<String> startCoords =
        _startCoordinatesTextController.text.split(',');
    final List<String> endCoords =
        _endCoordinatesTextController.text.split(',');
    final double startLatitude = double.parse(startCoords[0]);
    final double startLongitude = double.parse(startCoords[1]);
    final double endLatitude = double.parse(endCoords[0]);
    final double endLongitude = double.parse(endCoords[1]);

    final double distance = await Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      content: Text('The distance is: $distance'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                hintText: 'start latitude,start longitude'),
            controller: _startCoordinatesTextController,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration:
                const InputDecoration(hintText: 'end latitude,end longitude'),
            controller: _endCoordinatesTextController,
          ),
        ),
        RaisedButton(
          child: const Text(
            'Calculate',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(8.0),
          onPressed: () {
            _onCalculatePressed();
          },
        ),
      ],
    );
  }
}
