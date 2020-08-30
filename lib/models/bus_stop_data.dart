import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bus_stop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'networking.dart';

class BusStopData extends ChangeNotifier {
  SharedPreferences _sharedPreferences;
  List<BusStop> _stops = [];

  String _lastUpdated = DateFormat.jm().format(DateTime.now()).toLowerCase();

  void initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    // _sharedPreferences.clear();
    print('bus data init');
    loadData();
    notifyListeners();
    await refreshStops();
  }

  void saveData() {
    List<String> stopsList =
        _stops.map((item) => jsonEncode(item.toMap())).toList();
    _sharedPreferences.setStringList('bus_stops', stopsList);
  }

  void loadData() {
    List<String> stopsList = _sharedPreferences.getStringList('bus_stops');
    if (stopsList != null) {
      _stops =
          stopsList.map((item) => BusStop.fromMap(json.decode(item))).toList();
    }
  }

  bool addStop({
    String name,
    String direction,
    String stopID,
    String route,
    List<String> arrivalTimes,
  }) {
    bool isNewStop = true;

    for (BusStop stop in _stops) {
      if (stop.stopID == stopID && stop.route == route) {
        isNewStop = false;
      }
    }

    if (isNewStop) {
      _stops.add(BusStop(
        name: name,
        direction: direction,
        arrivalTimes: arrivalTimes,
        stopID: stopID,
        route: route,
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

  void undoDelete({BusStop stop, int index}) {
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
    // if (newIndex > oldIndex) {
    //   newIndex -= 1;
    // }
    BusStop stop = _stops[oldIndex];
    _stops.removeAt(oldIndex);
    _stops.insert(newIndex, stop);
    saveData();
    notifyListeners();
  }

  Future<void> refreshStops() async {
    Networking networking = Networking();
    List<List<String>> newArrivalData =
        await networking.refreshBusStopData(_stops);
    for (var i = 0; i < _stops.length; i++) {
      _stops[i].arrivalTimes = newArrivalData[i];
    }
    _lastUpdated = DateFormat.jm().format(DateTime.now()).toLowerCase();
    print("bus stops refreshed");
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
