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

  void _onCalculatePressed() async {
    var startCoords = _startCoordinatesTextController.text.split(',');
    var endCoords = _endCoordinatesTextController.text.split(',');
    var startLatitude = double.parse(startCoords[0]);
    var startLongitude = double.parse(startCoords[1]);
    var endLatitude = double.parse(endCoords[0]);
    var endLongitude = double.parse(endCoords[1]);

    double distance = await Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          content: new Text("The distance is: $distance"),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration:
                InputDecoration(hintText: "start latitude,start longitude"),
            controller: _startCoordinatesTextController,
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(hintText: "end latitude,end longitude"),
            controller: _endCoordinatesTextController,
          ),
        ),
        RaisedButton(
          child: Text(
            "Calculate",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(8.0),
          onPressed: () {
            _onCalculatePressed();
          },
        ),
      ],
    );
  }
}
