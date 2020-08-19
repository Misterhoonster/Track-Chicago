import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';

class TrainStopCard extends StatelessWidget {
  final String name;
  final String direction;
  final Color color;
  final Function onPressed;

  TrainStopCard({this.name, this.direction, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: this.color,
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(15.0),
              title: Text(
                this.name,
                style: cardTitleTextStyle,
              ),
              subtitle: Text(
                this.direction,
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
