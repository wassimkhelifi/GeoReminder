import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:georeminder/services/notification_plugin.dart';
import 'package:georeminder/utilities/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final NotificationPlugin notification = NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  @override
  void initState() {
    super.initState();
    notificationFuture = notification.getDayAndTimeNotification();
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
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color(0xff212121),
        body: SafeArea(
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
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key key,
    @required this.notification,
  }) : super(key: key);

  final PendingNotificationRequest notification;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          notification.title,
        ),
        subtitle: Text(
          notification.body,
        ),
      ),
    );
  }
}
