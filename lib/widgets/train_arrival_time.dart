import 'package:flutter/material.dart';

class TrainArrivalTime extends StatelessWidget {
  final arrivalTime;
  final Color color;

  TrainArrivalTime(this.arrivalTime, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              this.arrivalTime == '?' ? "n/a" : this.arrivalTime,
              style: TextStyle(
                color: this.color,
                fontSize: 20.0,
              ),
            ),
            this.arrivalTime == '?'
                ? Container()
                : Text(
                    "min",
                    style: TextStyle(
                      color: this.color,
                      fontSize: 10.0,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
