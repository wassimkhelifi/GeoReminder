import 'package:flutter/material.dart';
import 'package:georeminder/screens/reminders_screen.dart';
import 'package:georeminder/screens/new_reminder_screen.dart';
import 'package:georeminder/screens/map_search_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => RemindersScreen(),
        //'/currentreminder': (context) => CurrentReminder(),
        '/newreminderscreen': (context) => NewReminderScreen(),
        '/mapSearchScreen': (context) => MapSearchScreen(),
      },
    );
  }
}
