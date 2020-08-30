import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'bus_stop.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'package:track_chicago/api_key.dart';
import 'package:track_chicago/models/train_stop.dart';
import 'package:track_chicago/models/train_line.dart';
import 'package:track_chicago/constants.dart';

class Networking {
  final _baseURLTrain =
      'http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=$trainKey&outputType=json&max=7';

  Future<List> testTrainStopData() async {
    List map = [
      ['Red', redLineStops, redLineToHoward, redLineStops, redLineTo95],
      [
        'Blue',
        blueLineStops,
        blueLineToOhare,
        blueLineStops,
        blueLineToForestPark
      ],
      [
        'Brn',
        brownLineStopsKimball,
        brownLineToKimball,
        brownLineStopsLoop,
        brownLineToLoop
      ],
      [
        'G',
        greenLineStopsHarlem,
        greenLineToHarlem,
        greenLineStops63rd,
        greenLineTo63rd
      ],
      [
        'Org',
        orangeLineStopsMidway,
        orangeLineToMidway,
        orangeLineStopsLoop,
        orangeLineToLoop
      ],
      [
        'Pink',
        pinkLineStops54th,
        pinkLineTo54th,
        pinkLineStopsLoop,
        pinkLineToLoop
      ],
      [
        'P',
        purpleLineStopsLinden,
        purpleLineToLinden,
        purpleLineStopsLoop,
        purpleLineToLoop
      ],
      [
        'Y',
        yellowLineStops,
        yellowLineToHoward,
        yellowLineStops,
        yellowLineToSkokie
      ],
    ];

    List naughtybois = [];
    List noData = [];

    for (var line in map) {
      for (var i = 0; i < line[1].length; i++) {
        var stopID = line[2][i];
        var rt = line[0];
        var name = line[1][i];
        var response = await http.get('$_baseURLTrain&stpid=$stopID&rt=$rt');
        if (response.statusCode == 200) {
          var decoded = jsonDecode(response.body)['ctatt']['eta'];
          if (decoded != null) {
            if (name != decoded[0]['staNm']) {
              naughtybois.add({'name': name, 'stopID': stopID, 'rt': rt});
            }
          } else {
            noData.add({'name': name, 'stopID': stopID, 'rt': rt});
          }
        } else {
          print(response.statusCode);
        }
      }
      for (var j = 0; j < line[3].length; j++) {
        var stopID = line[4][j];
        var rt = line[0];
        var name = line[3][j];
        var response = await http.get('$_baseURLTrain&stpid=$stopID&rt=$rt');
        if (response.statusCode == 200) {
          var decoded = jsonDecode(response.body)['ctatt']['eta'];
          if (decoded != null) {
            if (name != decoded[0]['staNm']) {
              naughtybois.add({'name': name, 'stopID': stopID, 'rt': rt});
            }
          } else {
            noData.add({'name': name, 'stopID': stopID, 'rt': rt});
          }
        } else {
          print(response.statusCode);
        }
      }
      print('${line[0]} Line done!');
    }
    print('done');
    return [naughtybois, noData];
  }

  Future<List<String>> getTrainStopData(String rt, String stopID) async {
    var response = await http.get('$_baseURLTrain&stpid=$stopID&rt=$rt');
    List<String> arrivalTimes = [];

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body)['ctatt']['eta'];
      if (decoded != null) {
        for (var item in decoded) {
          String currentTime = item['prdt'];
          String arrivalTime = item['arrT'];
          int difference = DateTime.parse(arrivalTime)
              .difference(DateTime.parse(currentTime))
              .inMinutes;
          arrivalTimes.add(difference.toString());
        }
      } else {
        arrivalTimes.add('?');
        print('No data available');
      }
    } else {
      arrivalTimes.add('?');
      print(response.statusCode);
    }
    print(arrivalTimes);
    return arrivalTimes;
  }

  Future<List<List<String>>> refreshTrainStopData(List<TrainStop> stops) async {
    List<List<String>> arrivalTimes = [];

    for (TrainStop stop in stops) {
      String stopID = stop.stopID.toString();
      String rt = stop.rt;

      List<String> data = await getTrainStopData(rt, stopID);
      arrivalTimes.add(data);
    }

    // print(arrivalTimes);
    return arrivalTimes;
  }

  Stream<List> getTrainLinesStream() {
    StreamController<List> _controller;

    void getLines() async {
      List linesList = TrainLineData().data;

      _controller.add(linesList);
      _controller.close();
    }

    _controller = BehaviorSubject(onListen: getLines);

    return _controller.stream;
  }

  Stream<TrainLine> getTrainStopsStream(TrainLine line) {
    StreamController<TrainLine> _controller;

    void getLines() async {
      _controller.add(line);
      _controller.close();
    }

    _controller = BehaviorSubject(onListen: getLines);

    return _controller.stream;
  }

  Stream<List> getBusLinesStream() {
    StreamController<List> _controller;

    void getLines() async {
      List linesList = [];

      var lines = await rootBundle.loadString('assets/data/bus_line_data.json');
      var linesDecoded = jsonDecode(lines)["lines"];

      for (var line in linesDecoded) {
        String name = line['name'];
        String number = line['rt'];
        List directions = line['directions'];

        Map<String, dynamic> map = {};

        map['name'] = name;
        map['number'] = number;
        map['directions'] = directions;

        linesList.add(map);
        _controller.add(linesList);
      }
      _controller.close();
    }

    _controller = BehaviorSubject(onListen: getLines);

    return _controller.stream;
  }

  Stream<List<BusStop>> getBusStopsStream({String route, String direction}) {
    StreamController<List<BusStop>> _controller;

    //print(linesEncoded);

    void getStops() async {
      List<BusStop> _stops = [];
      String _stopsURL =
          'http://www.ctabustracker.com/bustime/api/v2/getstops?key=$busKey&format=json&rt=$route&dir=$direction';

      print('fetching stops...');

      var stopsResponse = await http.get(_stopsURL);

      if (stopsResponse.statusCode == 200) {
        var stopsDecoded =
            jsonDecode(stopsResponse.body)['bustime-response']['stops'];
        for (var stop in stopsDecoded) {
          String stopID = stop['stpid'];
          String stopName = stop['stpnm'];

          BusStop newStop = BusStop(
            name: stopName,
            direction: direction,
            stopID: stopID,
            route: route,
            arrivalTimes: [],
          );
          _stops.add(newStop);
          _controller.add(_stops);
        }
      } else {
        print(stopsResponse.statusCode);
        throw "ERROR with request";
      }
      _controller.close();
    }

    _controller = BehaviorSubject(onListen: getStops);

    return _controller.stream;
  }

  Future<List<String>> getBusStopData(String route, String stopID) async {
    String _busPredictionsURL =
        "http://www.ctabustracker.com/bustime/api/v2/getpredictions?key=$busKey&format=json";
    int maxPredictions = 7;
    var response = await http
        .get('$_busPredictionsURL&stpid=$stopID&rt=$route&top=$maxPredictions');

    List<String> arrivalTimes = [];

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body)['bustime-response']['prd'];
      if (decoded != null) {
        for (var item in decoded) {
          String currentTime = item['tmstmp'];
          String arrivalTime = item['prdtm'];
          int difference = DateTime.parse(arrivalTime)
              .difference(DateTime.parse(currentTime))
              .inMinutes;
          arrivalTimes.add(difference.toString());
        }
      } else {
        arrivalTimes.add('?');
        print('No data available');
      }
    } else {
      arrivalTimes.add('?');
      print(response.statusCode);
    }
    return arrivalTimes;
  }

  Future<List<List<String>>> refreshBusStopData(List<BusStop> stops) async {
    List<List<String>> arrivalTimes = [];

    for (BusStop stop in stops) {
      String stopID = stop.stopID;
      String route = stop.route;

      List data = await getBusStopData(route, stopID);
      arrivalTimes.add(data);
    }
    return arrivalTimes;
  }
}
