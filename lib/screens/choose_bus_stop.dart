import 'dart:async';

import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/models/networking.dart';

import 'package:track_chicago/models/bus_stop.dart';
import 'package:track_chicago/widgets/bus_stop_card.dart';

class BusStopScreen extends StatefulWidget {
  final String direction;
  final String route;

  BusStopScreen({this.direction, this.route});

  @override
  _BusStopScreenState createState() => _BusStopScreenState();
}

class _BusStopScreenState extends State<BusStopScreen> {
  Map<String, List<String>> stopsEncoded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0),
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
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                iconSize: 30.0,
                onPressed: () async {
                  Map<String, dynamic> passBackData = await showSearch(
                    context: context,
                    delegate: BusStopSearch(Networking().getBusStopsStream(
                        direction: widget.direction, route: widget.route)),
                  );
                  if (passBackData != null) {
                    Navigator.pop(context, passBackData);
                  }
                },
                color: Color(0xFFC0C0C0),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: StreamBuilder<List<BusStop>>(
              initialData: [],
              stream: Networking().getBusStopsStream(
                  direction: widget.direction, route: widget.route),
              builder: (context, snapshot) {
                Widget child;
                if (snapshot.hasError) {
                  child = Center(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      ],
                    ),
                  );
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      child = Container();
                      break;
                    case ConnectionState.waiting:
                      child = Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                      List<BusStop> stops = snapshot.data;
                      child = BuildStopsList(stops);
                      break;
                    case ConnectionState.done:
                      List<BusStop> stops = snapshot.data;
                      child = BuildStopsList(stops);
                      break;
                  }
                }
                return child;
              }),
        ),
      ),
    );
  }
}

class BuildStopsList extends StatelessWidget {
  final List<BusStop> stops;

  BuildStopsList(this.stops);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: stops.length,
        itemBuilder: (context, int index) {
          return BusStopCard(stop: stops[index]);
        });
  }
}

class BusStopSearch extends SearchDelegate<Map<String, dynamic>> {
  final Stream<List> stopsStream;

  BusStopSearch(this.stopsStream);

  List<Widget> clearButton() {
    if (query != '') {
      return [
        FlatButton(
          onPressed: () {
            query = '';
          },
          child: Text(
            'clear',
            style: TextStyle(
              color: trainColors['blue'],
              fontSize: 20.0,
            ),
          ),
        )
      ];
    } else {
      return [Container()];
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return clearButton();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    void _closeSearchPage(Map<String, dynamic> passBackData) {
      close(context, passBackData);
    }

    // TODO: implement buildResults
    return StreamBuilder<List<BusStop>>(
        initialData: [],
        stream: stopsStream, // stream data to listen for change
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasError) {
            child = Center(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ],
              ),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                child = Container();
                break;
              case ConnectionState.waiting:
                child = Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
                List<BusStop> stops = snapshot.data ?? [];
                List<BusStop> results = stops
                        .where((a) =>
                            a.name
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            a.route.toLowerCase().contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<BusStopCard>((a) => BusStopCard(
                              stop: a,
                              close: _closeSearchPage,
                            ))
                        .toList());
                break;
              case ConnectionState.done:
                List<BusStop> stops = snapshot.data ?? [];
                List<BusStop> results = stops
                        .where((a) =>
                            a.name
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            a.route.toLowerCase().contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map((a) => BusStopCard(
                              stop: a,
                              close: _closeSearchPage,
                            ))
                        .toList());
                break;
            }
          }
          return child;
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    void _closeSearchPage(Map<String, dynamic> passBackData) {
      close(context, passBackData);
    }

    // TODO: implement buildSuggestions
    return StreamBuilder<List<BusStop>>(
        initialData: [],
        stream: stopsStream, // stream data to listen for change
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasError) {
            child = Center(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ],
              ),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                child = Container();
                break;
              case ConnectionState.waiting:
                child = Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
                List<BusStop> stops = snapshot.data ?? [];
                List<BusStop> results = stops
                        .where((a) =>
                            a.name
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            a.route.toLowerCase().contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<BusStopCard>((a) => BusStopCard(
                              stop: a,
                              close: _closeSearchPage,
                            ))
                        .toList());
                break;
              case ConnectionState.done:
                List<BusStop> stops = snapshot.data ?? [];
                List<BusStop> results = stops
                        .where((a) =>
                            a.name
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            a.route.toLowerCase().contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<BusStopCard>((a) => BusStopCard(
                              stop: a,
                              close: _closeSearchPage,
                            ))
                        .toList());
                break;
            }
          }
          return child;
        });
  }
}
