import 'package:flutter/material.dart';
import 'package:track_chicago/constants.dart';

class BusArrivalTime extends StatelessWidget {
  final arrivalTime;

  BusArrivalTime(this.arrivalTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: busBlue, width: 4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              this.arrivalTime == '?' ? "n/a" : this.arrivalTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: busBlue,
                fontSize: 20.0,
              ),
            ),
            this.arrivalTime == '?'
                ? Container()
                : Text(
                    "min",
                    style: TextStyle(
                      color: busBlue,
                      fontSize: 10.0,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
