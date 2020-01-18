import 'package:georeminder/services/notification_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationCheck{
  Geolocator geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  NotificationPlugin newNotification = NotificationPlugin();

  double destinationLatitude;
  double destinationLongitude;
  int locationId;
  String title;
  String description;

  LocationCheck(this.destinationLatitude, this.destinationLongitude, this.locationId, this.title, this.description){
    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
    (Position position) async {
      double distanceInMeters = await geolocator.distanceBetween(position.latitude, position.longitude, destinationLatitude, destinationLongitude);
      if (distanceInMeters < 100){
        newNotification.makeNotification(locationId, title, description);
      }
    });
  }

}