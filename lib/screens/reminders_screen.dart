import 'package:flutter/material.dart';
import 'package:georeminder/utilities/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:georeminder/screens/new_reminder_screen.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen>{
  @override
  void initState() {
    super.initState();
  }

  int sharedValue = 0;

  Widget platformScaffoldReminder(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        backgroundColor: Color(0xff212121),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                backgroundColor: Color(0xff212121),
                largeTitle: Text(
                  'Reminders',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/newreminderscreen');
                  },
                  child: Icon(
                    Icons.add_alert,
                    color: Colors.white,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int id){
                  return Card(
                    elevation: 10.0,
                    color: Color(0xff424242),
                    child: ListTile(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => SimpleDialog(
                            title: Center(
                              child: Text(
                                notifications[id].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            backgroundColor: Color(0xff424242),
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  notifications[id].description,
                                  textAlign: TextAlign.center,
                                    //maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 2,
                              ),
                              Center(
                                child: Text(
                                  notifications[id].scheduledDate == null 
                                    ? locationAddress
                                    : DateFormat.yMMMMEEEEd().add_jm().format(notifications[id].scheduledDate),
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 2,
                              ),
                              RaisedButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                color: Colors.blueGrey,
                                child: Text(
                                  'Return', 
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  ),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        onPressed: (){
                          setState(() {
                            notificationPlugins[id].cancelNotification(id);
                            notifications.removeAt(id);
                            locationNotifications.removeAt(locationId);
                          });
                          print(id);
                        },
                         icon: Icon(
                         Icons.delete,
                         color: Colors.white,
                         size: 30.0, 
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20.0),
                      title: Text(
                        notifications[id].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: AutoSizeText(
                        notifications[id].scheduledDate == null
                          ? locationAddress
                          : DateFormat.yMMMMEEEEd().add_jm().format(notifications[id].scheduledDate),
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  );
                },
                childCount: notifications.length,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color(0xff212121),
        body: SizedBox(
            height: SizeConfig.blockSizeVertical*100,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Color(0xff212121),
                  title: Text(
                    'Reminders',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/newreminderscreen');
                      },
                      child: Icon(
                        Icons.add_alert,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int id){
                  return Card(
                    elevation: 10.0,
                    color: Color(0xff424242),
                    child: ListTile(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => SimpleDialog(
                            title: Center(
                              child: Text(
                                notifications[id].title,
                                //maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            backgroundColor: Color(0xff424242),
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  notifications[id].description,
                                  textAlign: TextAlign.center,
                                    //maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 2,
                              ),
                              Center(
                                child: Text(
                                  notifications[id].scheduledDate == null 
                                    ? locationAddress
                                    : DateFormat.yMMMMEEEEd().add_jm().format(notifications[id].scheduledDate),
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 2,
                              ),
                              RaisedButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                color: Colors.blueGrey,
                                child: Text(
                                  'Return', 
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  ),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        onPressed: (){
                          setState(() {
                            notificationPlugins[id].cancelNotification(id);
                            notifications.removeAt(id);
                            locationNotifications.removeAt(locationId);
                          });
                          print(id);
                        },
                         icon: Icon(
                         Icons.delete,
                         color: Colors.white,
                         size: 30.0, 
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20.0),
                      title: Text(
                        notifications[id].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: AutoSizeText(
                        notifications[id].scheduledDate == null
                          ? locationAddress
                          : DateFormat.yMMMMEEEEd().add_jm().format(notifications[id].scheduledDate),
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  );
                },
                childCount: notifications.length,
                ),
                ),
              ],
            ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return platformScaffoldReminder(context);
  }

  // @override
  // bool get wantKeepAlive => true;
}


