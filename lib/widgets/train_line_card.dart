import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/screens/choose_train_stop_screen.dart';
import 'package:track_chicago/models/train_line.dart';

class TrainLineCard extends StatelessWidget {
  final List<TrainLine> lines;

  TrainLineCard({this.lines});

  @override
  Widget build(BuildContext context) {
    List<Widget> buildTiles() {
      return lines.map((item) {
        return LineTile(line: item);
      }).toList();
    }

    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: this.lines[0].color,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            title: Text(
              this.lines[0].name,
              style: cardTitleTextStyle,
            ),
          ),
          ...buildTiles(),
        ],
      ),
    );
  }
}

class LineTile extends StatelessWidget {
  LineTile({this.line});

  final TrainLine line;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          thickness: 1.0,
          height: 0.0,
        ),
        GestureDetector(
          onTap: () async {
            Map<String, dynamic> passBackData = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
              return TrainStopScreen(line);
            }));
            Navigator.pop(context, passBackData);
          },
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 15.0),
            title: Text(
              this.line.direction,
              style: cardSubtitleTextStyle,
            ),
            trailing: Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
