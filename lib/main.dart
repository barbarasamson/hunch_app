import 'package:flutter/material.dart';

import 'package:hunch_app/pages/play.dart';
import 'package:hunch_app/pages/settings.dart';
import 'package:hunch_app/pages/analysis.dart';


void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => PlayScreen(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/settings': (context) => SettingsScreen(),
      '/analysis': (context) => AnalysisScreen(),

    },
  ));
}
