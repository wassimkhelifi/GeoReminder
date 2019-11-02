import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

int sharedValue = 0;

final Map<int, Widget> logoWidgets = const <int, Widget>{
  0: Text('Date/Time'),
  1: Text('Place'),
};
