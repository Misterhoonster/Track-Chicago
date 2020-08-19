import 'package:flutter/material.dart';

class TrainStop {
  final String name;
  final String direction;
  final Color color;
  final int stopID;
  final String rt;
  List<String> arrivalTimes;

  TrainStop(
      {this.name,
      this.direction,
      this.arrivalTimes,
      this.color,
      this.stopID,
      this.rt});

  TrainStop.fromMap(Map<String, dynamic> map)
      : this.name = map['name'],
        this.direction = map['direction'],
        this.arrivalTimes = map['arrivalTimes'].split(" "),
        this.color = Color(map['color']),
        this.stopID = map['stopID'],
        this.rt = map['rt'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'direction': direction,
      'arrivalTimes': arrivalTimes.join(' '),
      'color': color.value,
      'stopID': stopID,
      'rt': rt,
    };
  }
}
