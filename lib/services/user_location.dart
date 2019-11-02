import 'package:geolocator/geolocator.dart';

class UserLocation {
  double longitude;
  double latitude;

  void getUserLocation() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      longitude = position.longitude;
      latitude = position.latitude;
    });
  }
}
