import 'package:flutter/material.dart';
import 'package:track_chicago/constants.dart';

import 'package:track_chicago/models/bus_stop_data.dart';
import 'package:track_chicago/models/flushbars.dart';
import 'package:track_chicago/screens/choose_bus_line.dart';
import 'package:provider/provider.dart';
import 'package:track_chicago/widgets/bus_stops_list_view.dart';

class BusScreen extends StatefulWidget {
  BusScreen({Key key}) : super(key: key);

  @override
  _BusScreenState createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  @override
  void initState() {
    super.initState();
    BusStopData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 45.0,
            left: 30.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'last updated',
                        style: lastUpdatedTextStyle,
                      ),
                      Text(
                        Provider.of<BusStopData>(context).lastUpdated,
                        style: lastUpdatedTimeTextStyle,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Image.asset('assets/icons/plus button.png'),
                    onPressed: () {
                      navigateAndDisplayFlushbar(context, BusLineScreen());
                    },
                    color: Colors.grey,
                    iconSize: 50.0,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 15,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              child: BusStopsListView(),
            ),
          ),
        ),
      ],
    );
  }
}
