import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/models/bus_stop.dart';

import 'package:track_chicago/models/networking.dart';
import 'package:track_chicago/models/bus_stop_data.dart';
import 'package:provider/provider.dart';

class BusStopCard extends StatelessWidget {
  final BusStop stop;
  final Function close;

  BusStopCard({this.stop, this.close});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: busBlue, width: 4.0),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              Networking addRoute = Networking();
              List<String> arrivalTimes =
                  await addRoute.getBusStopData(stop.route, stop.stopID);
              bool success =
                  Provider.of<BusStopData>(context, listen: false).addStop(
                name: stop.name,
                direction: stop.direction,
                arrivalTimes: arrivalTimes,
                stopID: stop.stopID,
                route: stop.route,
              );
              Map<String, dynamic> passBackData = {
                'success': success,
                'name': stop.name,
                'direction': stop.direction,
                'route': stop.route,
              };

              if (close != null) {
                close(passBackData);
              } else {
                Navigator.pop(context, passBackData);
              }
            },
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
              leading: Text(
                stop.route,
                style: busNumberTextStyle,
              ),
              title: Text(
                stop.name,
                style: busTitleTextStyle,
              ),
              subtitle: Text(stop.direction, style: busSubtitleTextStyle),
            ),
          ),
        ],
      ),
    );
  }
}
