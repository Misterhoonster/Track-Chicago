import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'train_stop.dart';
import 'package:track_chicago/models/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainStopData extends ChangeNotifier {
  SharedPreferences _sharedPreferences;
  List<TrainStop> _stops = [];
  String _lastUpdated = DateFormat.jm().format(DateTime.now()).toLowerCase();

  TrainStopData() {
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    // _sharedPreferences.clear();
    print('train init');
    loadData();
    notifyListeners();
  }

  void saveData() {
    List<String> stopsList =
        _stops.map((item) => jsonEncode(item.toMap())).toList();
    _sharedPreferences.setStringList('train_stops', stopsList);
  }

  void loadData() {
    List<String> stopsList = _sharedPreferences.getStringList('train_stops');
    if (stopsList != null) {
      _stops = stopsList
          .map((item) => TrainStop.fromMap(json.decode(item)))
          .toList();
    }
  }

  bool addStop(
      {String name,
      String direction,
      List<String> arrivalTimes,
      Color color,
      int stopID,
      String rt}) {
    bool isNewStop = true;

    for (TrainStop stop in _stops) {
      if (stop.stopID == stopID && stop.rt == rt) {
        isNewStop = false;
      }
    }

    if (isNewStop) {
      _stops.add(TrainStop(
        name: name,
        direction: direction,
        arrivalTimes: arrivalTimes,
        color: color,
        stopID: stopID,
        rt: rt,
      ));
      refreshStops();
      saveData();
      notifyListeners();
      return true;
    } else {
      refreshStops();
      notifyListeners();
      return false;
    }
  }

  void undoDelete({TrainStop stop, int index}) {
    _stops.insert(index, stop);
    saveData();
    notifyListeners();
  }

  void removeStop(int index) {
    _stops.removeAt(index);
    saveData();
    notifyListeners();
  }

  void reorderStops(int oldIndex, int newIndex) {
    TrainStop stop = _stops[oldIndex];
    _stops.removeAt(oldIndex);
    _stops.insert(newIndex, stop);
    saveData();
    notifyListeners();
  }

  Future<void> refreshStops() async {
    Networking networking = Networking();
    List<List<String>> newArrivalData =
        await networking.refreshTrainStopData(_stops);
    for (var i = 0; i < _stops.length; i++) {
      _stops[i].arrivalTimes = newArrivalData[i];
    }
    _lastUpdated = DateFormat.jm().format(DateTime.now()).toLowerCase();
    print("train stops refreshed");
    saveData();
    notifyListeners();
  }

  String get lastUpdated {
    return _lastUpdated;
  }

  int get stopCount {
    return _stops.length;
  }

  UnmodifiableListView get stops {
    return UnmodifiableListView(_stops);
  }
}
