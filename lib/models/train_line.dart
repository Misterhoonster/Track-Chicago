import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';

class TrainLine {
  final String name;
  final List<String> stops;
  final String direction;
  final Color color;
  final List<int> stopIDs;
  final String rt;

  TrainLine(
      {this.name,
      this.stops,
      this.direction,
      this.color,
      this.stopIDs,
      this.rt});
}

class TrainLineData {
  List<List<TrainLine>> data = [
    [
      TrainLine(
        name: 'Red Line',
        stops: redLineStops,
        direction: "to Howard",
        color: trainColors["red"],
        stopIDs: redLineToHoward,
        rt: 'Red',
      ),
      TrainLine(
        name: 'Red Line',
        stops: redLineStops,
        direction: "to 95th",
        color: trainColors["red"],
        stopIDs: redLineTo95,
        rt: 'Red',
      )
    ],
    [
      TrainLine(
        name: 'Blue Line',
        stops: blueLineStops,
        direction: "to O\'Hare",
        color: trainColors["blue"],
        stopIDs: blueLineToOhare,
        rt: 'Blue',
      ),
      TrainLine(
        name: 'Blue Line',
        stops: blueLineStops,
        direction: "to Forest Park",
        color: trainColors["blue"],
        stopIDs: blueLineToForestPark,
        rt: 'Blue',
      )
    ],
    [
      TrainLine(
        name: 'Brown Line',
        stops: brownLineStopsKimball,
        direction: "to Kimball",
        color: trainColors["brown"],
        stopIDs: brownLineToKimball,
        rt: 'Brn',
      ),
      TrainLine(
        name: 'Brown Line',
        stops: brownLineStopsLoop,
        direction: "to Loop",
        color: trainColors['brown'],
        stopIDs: brownLineToLoop,
        rt: 'Brn',
      )
    ],
    [
      TrainLine(
        name: 'Green Line',
        stops: greenLineStopsHarlem,
        direction: "to Harlem",
        color: trainColors['green'],
        stopIDs: greenLineToHarlem,
        rt: 'G',
      ),
      TrainLine(
        name: 'Green Line',
        stops: greenLineStops63rd,
        direction: "to 63rd",
        color: trainColors["green"],
        stopIDs: greenLineTo63rd,
        rt: 'G',
      ),
      TrainLine(
        name: 'Green Line',
        stops: greenLineStopsCottageGrove,
        direction: "to Cottage Grove",
        color: trainColors["green"],
        stopIDs: greenLineToCottageGrove,
        rt: 'G',
      ),
    ],
    [
      TrainLine(
        name: 'Orange Line',
        stops: orangeLineStopsMidway,
        direction: "to Midway Airport",
        color: trainColors["orange"],
        stopIDs: orangeLineToMidway,
        rt: 'Org',
      ),
      TrainLine(
        name: 'Orange Line',
        stops: orangeLineStopsLoop,
        direction: "to Loop",
        color: trainColors["orange"],
        stopIDs: orangeLineToLoop,
        rt: 'Org',
      )
    ],
    [
      TrainLine(
        name: 'Pink Line',
        stops: pinkLineStops54th,
        direction: "to 54th",
        color: trainColors["pink"],
        stopIDs: pinkLineTo54th,
        rt: 'Pink',
      ),
      TrainLine(
        name: 'Pink Line',
        stops: pinkLineStopsLoop,
        direction: "to Loop",
        color: trainColors["pink"],
        stopIDs: pinkLineToLoop,
        rt: 'Pink',
      )
    ],
    [
      TrainLine(
        name: 'Purple Line',
        stops: purpleLineStopsLinden,
        direction: "to Linden",
        color: trainColors['purple'],
        stopIDs: purpleLineToLinden,
        rt: 'P',
      ),
      TrainLine(
        name: 'Purple Line',
        stops: purpleLineStopsLoop,
        direction: "to Loop",
        color: trainColors["purple"],
        stopIDs: purpleLineToLoop,
        rt: 'P',
      )
    ],
    [
      TrainLine(
        name: 'Yellow Line',
        stops: yellowLineStops,
        direction: "to Skokie",
        color: trainColors['yellow'],
        stopIDs: yellowLineToSkokie,
        rt: 'Y',
      ),
      TrainLine(
        name: 'Yellow Line',
        stops: yellowLineStops,
        direction: "to Howard",
        color: trainColors['yellow'],
        stopIDs: yellowLineToHoward,
        rt: 'Y',
      )
    ],
  ];
}
