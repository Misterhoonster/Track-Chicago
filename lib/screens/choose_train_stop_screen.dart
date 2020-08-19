import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/models/train_line.dart';
import 'package:track_chicago/widgets/train_stop_card.dart';
import 'package:track_chicago/models/networking.dart';
import 'package:track_chicago/models/train_stop_data.dart';

class TrainStopScreen extends StatelessWidget {
  final TrainLine line;

  TrainStopScreen(this.line);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
          child: AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.close),
              iconSize: 30.0,
              onPressed: () {
                Navigator.pop(context);
              },
              color: Color(0xFFC0C0C0),
            ),
            title: Text(
              "add new stop",
              style: lastUpdatedTimeTextStyle,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ListView.builder(
          itemCount: this.line.stops.length,
          itemBuilder: (context, index) {
            String stop = this.line.stops[index];
            return TrainStopCard(
              name: stop,
              direction: this.line.direction,
              color: this.line.color,
              onPressed: () async {
                Networking addRoute = Networking();
                bool success;
                List<String> arrivalTimes = await addRoute.getTrainStopData(
                    this.line.rt, this.line.stopIDs[index].toString());
                success =
                    Provider.of<TrainStopData>(context, listen: false).addStop(
                  name: stop,
                  direction: this.line.direction,
                  arrivalTimes: arrivalTimes,
                  color: this.line.color,
                  stopID: this.line.stopIDs[index],
                  rt: this.line.rt,
                );
                Map<String, dynamic> passBackData = {
                  'success': success,
                  'name': stop,
                  'direction': line.direction,
                };
                Navigator.pop(context, passBackData);
              },
            );
          },
        ),
      ),
    );
  }
}
