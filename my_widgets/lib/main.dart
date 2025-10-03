import 'package:flutter/material.dart';
import 'package:my_widgets/LocationWidgets/location_show_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LocationShow(
          initialLatitude: 33.531755,
          initialLongitude: 36.357392,
          onLocationChanged: (L) {},
        ),
      ),
    );
  }
}
