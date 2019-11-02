import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geocoding.dart';

const googleApiKey;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);

class MapSearchScreen extends StatefulWidget {
  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  double latitude;
  double longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: Container(
        alignment: Alignment.center,
        child: RaisedButton(
          onPressed: () {
            print('test');
          },
          child: Text(
            'test',
          ),
        ),
      ),
    );
  }
}
