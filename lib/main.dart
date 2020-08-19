import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:track_chicago/models/train_stop_data.dart';
import 'package:track_chicago/models/bus_stop_data.dart';
import 'package:track_chicago/widgets/bottom_nav_bar.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TrainStopData>(
            create: (context) => TrainStopData()),
        ChangeNotifierProvider<BusStopData>(create: (context) => BusStopData()),
      ],
      child: MaterialApp(
        home: BottomNavBar(),
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
              color: Color(0xFFC0C0C0),
              fontSize: 20.0,
            ),
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 20.0,
              color: Color(0xFFC0C0C0),
            ),
          ),
        ),
      ),
    );
  }
}
