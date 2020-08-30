import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/models/train_line.dart';
import 'package:track_chicago/models/networking.dart';
import 'package:track_chicago/models/train_stop_data.dart';

class TrainStopCard extends StatelessWidget {
  final Map stop;
  final TrainLine line;
  final Function close;

  TrainStopCard({this.stop, this.line, this.close});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Networking addRoute = Networking();
        bool success;
        List<String> arrivalTimes = await addRoute.getTrainStopData(
            line.rt, line.stopIDs[stop['index']].toString());
        success = Provider.of<TrainStopData>(context, listen: false).addStop(
          name: stop['name'],
          direction: line.direction,
          arrivalTimes: arrivalTimes,
          color: line.color,
          stopID: line.stopIDs[stop['index']],
          rt: line.rt,
        );
        Map<String, dynamic> passBackData = {
          'success': success,
          'name': stop['name'],
          'direction': line.direction,
        };
        if (close != null) {
          close(passBackData);
        } else {
          Navigator.pop(context, passBackData);
        }
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: line.color,
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(15.0),
              title: Text(
                stop['name'],
                style: cardTitleTextStyle,
              ),
              subtitle: Text(
                line.direction,
                style: cardSubtitleTextStyle,
              ),
              trailing: Icon(
                Icons.add,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
