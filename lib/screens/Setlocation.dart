import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeolocationScreen extends StatefulWidget {
  @override
  _GeolocationScreenState createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('messages');
  Position? _currentPosition;
  void initState() {
    super.initState();
    _initializeCurrentPosition();
  }

  void _initializeCurrentPosition() async {
    void _initializeCurrentPosition() async {
      _currentPosition = await Geolocator.getCurrentPosition();
      print("geolocalisaton");
      print(_currentPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocation '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _currentPosition != null
                  ? 'Latitude: ${_currentPosition?.latitude}, Longitude: ${_currentPosition?.longitude}'
                  : 'Location not available',
            ),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('Get Location'),
            ),
            ElevatedButton(
              onPressed: _saveLocation,
              child: Text('Save Location to Firebase'),
            ),
            ElevatedButton(
              onPressed: _compareLocations,
              child: Text('Compare Locations'),
            ),
          ],
        ),
      ),
    );
  }

  // Get the current location
  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      _currentPosition = position;
    });
  }

  // Save the location to Firebase
  void _saveLocation() {
    if (_currentPosition != null) {
      users.add(_currentPosition).then((value) => {print("save locaion okay")});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location saved to Firebase!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No location available to save!'),
      ));
    }
  }

  // Compare the locations
  void _compareLocations() async {
    // You can retrieve the locations from Firebase and compare them here
    // For simplicity, let's assume you have already implemented this logic
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Comparing locations...'),
    ));
  }
}
