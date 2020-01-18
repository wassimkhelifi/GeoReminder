import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:georeminder/services/notification_plugin.dart';
import 'package:georeminder/utilities/size_config.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:georeminder/services/named_notification.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:georeminder/services/location_check.dart';

const googleApiKey;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);
List<NamedNotification> notifications = [];
List<NotificationPlugin> notificationPlugins = [];
List<LocationCheck> locationNotifications = [];
int id = 0;
int locationId = 0;
var placeId, address;
double locationLatitude;
double locationLongitude;
String locationAddress;


class NewReminderScreen extends StatefulWidget {
  @override
  _NewReminderScreenState createState() => _NewReminderScreenState();
}

class _NewReminderScreenState extends State<NewReminderScreen> {

  void initState(){
    super.initState();
    //getCurrentLocation();
  }

  static String title;
  static String description;
  static DateTime _dateTime;

  int sharedValue = 0;

  final Map<int, Widget> dateTimePlace = const <int, Widget>{
    0: Text('Time'),
    1: Text('Place'),
  };

  String convertDate(DateTime date) {
    DateFormat dateFormat = DateFormat("EEEE, LLL d, yyyy, h:mm a");
    String string = dateFormat.format(date);
    return string;
  }

  double _kPickerSheetHeight = SizeConfig.blockSizeVertical * 20;

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget androidbuildPage(int index){ //build the native android user experience
    switch (index) {
      case 0: // If User picks a Time Reminder
        return SingleChildScrollView(
          child: Container(
            height: SizeConfig.blockSizeVertical * 100,
            child: Column(
              children: [
                SizedBox(
                  // Space from top
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                Container(
                  // New title
                  padding:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                  child: Row(
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Title TextField
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: TextField(
                    maxLines: 1,
                    onChanged: (value) {
                      title = value;
                    },
                    style: TextStyle(
                      color: Color(0xff212121),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter a title for your reminder',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  // Space Between TextFields
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                Container(
                  // New Description title
                  padding:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                  child: Row(
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Description TextField
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (value) {
                      description = value;
                    },
                    style: TextStyle(
                      color: Color(0xff212121),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter a description for your reminder',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  // Space Between TextFields
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                AutoSizeText(
                  // Represents the selected date
                  _dateTime == null
                      ? 'No time has been picked'
                      : convertDate(_dateTime),
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  // Space Between TextFields
                  height: SizeConfig.blockSizeVertical * 2,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                RaisedButton(
                  // Button that allows you to access the CupertinoDatePicker
                  child: Text(
                    'Select a Time',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(20.0),
                  color: Color(0xff424242),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        15.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(2018, 3, 5),
                      maxTime: DateTime(2030, 6, 7),
                      onChanged: (date){
                        _dateTime = date;
                      },
                    );
                  },
                ),
                SizedBox(
                  // Space Between TextFields
                  height: SizeConfig.blockSizeVertical * 10,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 90,
                  child: RaisedButton(
                    child: Text(
                      'Create Reminder',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    color: Color(0xffff3f80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        NotificationPlugin newNotification = NotificationPlugin();
                        newNotification.showAtDayAndTimeNotification(_dateTime, id, title, description);
                        notificationPlugins.add(newNotification);
                        NamedNotification listNotification = NamedNotification(_dateTime, null, id, title, description, true);
                        notifications.add(listNotification);
                        id = id + 1;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case 1: // If User picks a Place Reminder
        return SingleChildScrollView(
          child: Container(
            height: SizeConfig.blockSizeVertical * 100,
            child: Column(
              children: [
                SizedBox(
                  // Space from top
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                Container(
                  // New title title
                  padding:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                  child: Row(
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Title TextField
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: TextField(
                    maxLines: 1,
                    onChanged: (value) {
                      title = value;
                      // print(title);
                    },
                    style: TextStyle(
                      color: Color(0xff212121),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter a title for your reminder',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  // Space Between TextFields
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                Container(
                  // New Description title
                  padding:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                  child: Row(
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Description TextField
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (value) {
                      description = value;
                    },
                    style: TextStyle(
                      color: Color(0xff212121),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter a description for your reminder',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  // Space Between TextFields
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                AutoSizeText(
                  locationAddress == null 
                    ? 'The address should appear here'
                    : locationAddress,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  // Space Between TextFields
                  height: SizeConfig.blockSizeVertical * 2,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                Container(
                  child: RaisedButton(
                    child: Text(
                      'Select a Place',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    color: Color(0xff424242),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      Prediction prediction = await PlacesAutocomplete.show(
                        context: context, 
                        apiKey: googleApiKey,
                        //location: Location(currentPosition.latitude, currentPosition.longitude),
                        radius: 100000000,
                        mode: Mode.overlay,
                        language: "en",
                      );
                      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId);
                      setState(() {
                        locationAddress = prediction.description;
                        locationLatitude = detail.result.geometry.location.lat;
                        locationLongitude = detail.result.geometry.location.lng;
                      });
                    },
                  ),
                ),
                SizedBox(
                  // Space Between TextFields
                  height: SizeConfig.blockSizeVertical * 10,
                  width: SizeConfig.blockSizeHorizontal * 100,
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 90,
                  child: RaisedButton(
                    child: Text(
                      'Create Reminder',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    color: Color(0xffff3f80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        NamedNotification listNotification = NamedNotification(null, locationAddress, id, title, description, true);
                        notifications.add(listNotification);
                        id = id + 1;
                        LocationCheck locationNotification = LocationCheck(locationLatitude, locationLongitude, locationId, title, description);
                        locationNotifications.add(locationNotification);
                        locationId = locationId + 1;
                      });
                      Navigator.pop(context);
                    }
                  ),
                ),
              ],
            ),
          ),
        );
    }
    return Container();
  }

  Widget iosbuildPage(int index) { //build the native ios user experience
    switch (index) {
      case 0: // If User picks a Time Reminder
        return Container(
          height: SizeConfig.blockSizeVertical * 100,
          child: Column(
            children: [
              SizedBox(
                // Space from top
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              Container(
                // New title
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Row(
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // Title TextField
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: TextField(
                  maxLines: 1,
                  onChanged: (value) {
                    title = value;
                  },
                  style: TextStyle(
                    color: Color(0xff212121),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter a title for your reminder',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // Space Between TextFields
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              Container(
                // New Description title
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Row(
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // Description TextField
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    description = value;
                  },
                  style: TextStyle(
                    color: Color(0xff212121),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter a description for your reminder',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // Space Between TextFields
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              AutoSizeText(
                // Represents the selected date
                _dateTime == null
                    ? 'No time has been picked'
                    : convertDate(_dateTime),
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                // Space Between TextFields
                height: SizeConfig.blockSizeVertical * 2,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              RaisedButton(
                // Button that allows you to access the CupertinoDatePicker
                child: Text(
                  'Select a Time',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.all(20.0),
                color: Color(0xff424242),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      15.0,
                    ),
                  ),
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildBottomPicker(
                          CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: (DateTime date) {
                              setState(() {
                                _dateTime = date;
                              });
                            },
                          ),
                        );
                      });
                },
              ),
              SizedBox(
                // Space Between TextFields
                height: SizeConfig.blockSizeVertical * 15,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 90,
                child: RaisedButton(
                  child: Text(
                    'Create Reminder',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(20.0),
                  color: Color(0xffff3f80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        15.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      NotificationPlugin newNotification = NotificationPlugin();
                      newNotification.showAtDayAndTimeNotification(_dateTime, id, title, description);
                      notificationPlugins.add(newNotification);
                      NamedNotification listNotification = NamedNotification(_dateTime, null, id, title, description, true);
                      notifications.add(listNotification);
                      id = id + 1;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 1: // If User picks a Place Reminder
        return Container(
          height: SizeConfig.blockSizeVertical * 100,
          child: Column(
            children: [
              SizedBox(
                // Space from top
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              Container(
                // New title title
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Row(
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // Title TextField
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: TextField(
                  maxLines: 1,
                  onChanged: (value) {
                    title = value;
                    // print(title);
                  },
                  style: TextStyle(
                    color: Color(0xff212121),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter a title for your reminder',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // Space Between TextFields
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              Container(
                // New Description title
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Row(
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // Description TextField
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    description = value;
                  },
                  style: TextStyle(
                    color: Color(0xff212121),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter a description for your reminder',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // Space Between TextFields
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              AutoSizeText(
                locationAddress == null 
                  ? 'The address should appear here'
                  : locationAddress,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                // Space Between TextFields
                height: SizeConfig.blockSizeVertical * 2,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              Container(
                child: RaisedButton(
                  child: Text(
                    'Select a Place',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(20.0),
                  color: Color(0xff424242),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        15.0,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Prediction prediction = await PlacesAutocomplete.show(
                      context: context, 
                      apiKey: googleApiKey,
                      //location: Location(currentPosition.latitude, currentPosition.longitude),
                      radius: 100000000,
                      mode: Mode.overlay,
                      language: "en",
                    );
                    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId);
                    setState(() {
                      locationAddress = prediction.description;
                      locationLatitude = detail.result.geometry.location.lat;
                      locationLongitude = detail.result.geometry.location.lng;
                    });
                  },
                ),
              ),
              SizedBox(
                // Space Between TextFields
                height: SizeConfig.blockSizeVertical * 15,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 90,
                child: RaisedButton(
                  child: Text(
                    'Create Reminder',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(20.0),
                  color: Color(0xffff3f80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        15.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      NamedNotification listNotification = NamedNotification(null, locationAddress, id, title, description, true);
                      notifications.add(listNotification);
                      id = id + 1;
                      LocationCheck locationNotification = LocationCheck(locationLatitude, locationLongitude, locationId, title, description);
                      locationNotifications.add(locationNotification);
                      locationId = locationId + 1;
                    });
                    Navigator.pop(context);
                  }
                ),
              ),
            ],
          ),
        );
    }
    return Container();
  }


  Widget platformScaffoldNewReminder(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        backgroundColor: Color(0xff212121),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                backgroundColor: Color(0xff212121),
                largeTitle: Text(
                  'New Reminder',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                middle: SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 45,
                  child: CupertinoSegmentedControl<int>(
                    borderColor: Colors.white,
                    unselectedColor: Color(0xff212121),
                    selectedColor: Colors.white,
                    children: dateTimePlace,
                    onValueChanged: (int val) {
                      setState(() {
                        sharedValue = val;
                      });
                    },
                    groupValue: sharedValue,
                  ),
                ),
                trailing: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    iosbuildPage(sharedValue),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
        backgroundColor: Color(0xff212121),
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Time',
              ),
              Tab(
                text: 'Place',
              ),
            ],
            indicatorColor: Colors.white,
          ),
          title: Text('New Reminder'),
          backgroundColor: Color(0xff212121),
        ),
        body: TabBarView(
          children: <Widget>[
            androidbuildPage(0),
            androidbuildPage(1),
          ],
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return platformScaffoldNewReminder(context);
    }
  }