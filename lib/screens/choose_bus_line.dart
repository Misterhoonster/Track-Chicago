import 'dart:async';

import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/models/networking.dart';
import 'package:track_chicago/screens/choose_bus_stop.dart';

import 'package:track_chicago/widgets/bus_line_card.dart';

class BusLineScreen extends StatefulWidget {
  @override
  _BusLineScreenState createState() => _BusLineScreenState();
}

class _BusLineScreenState extends State<BusLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                  Map<String, dynamic> searchPassBack = await showSearch(
                    context: context,
                    delegate: BusLineSearch(Networking().getBusLinesStream()),
                  );

                  if (searchPassBack != null) {
                    Map<String, dynamic> passBackData = await Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                      return BusStopScreen(
                        direction: searchPassBack['direction'],
                        route: searchPassBack['route'],
                      );
                    }));

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
          child: StreamBuilder<List>(
              initialData: [],
              stream: Networking()
                  .getBusLinesStream(), // stream data to listen for change
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
                      List lines = snapshot.data;
                      child = BuildRoutesList(lines);
                      break;
                    case ConnectionState.done:
                      List lines = snapshot.data;
                      child = BuildRoutesList(lines);
                      print('Done loading bus lines!');
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

class BuildRoutesList extends StatelessWidget {
  final List routes;

  BuildRoutesList(this.routes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, int index) {
          return BusLineCard(line: routes[index]);
        });
  }
}

class BusLineSearch extends SearchDelegate<Map<String, dynamic>> {
  final Stream<List> routesStream;

  BusLineSearch(this.routesStream);

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
      iconSize: 30.0,
      color: Color(0xFFC0C0C0),
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
    return StreamBuilder<List>(
        initialData: [],
        stream: routesStream, // stream data to listen for change
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
                List lines = snapshot.data ?? [];
                List results = lines
                        .where((a) =>
                            a['name']
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            a['number']
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<BusLineCard>((a) => BusLineCard(
                              line: a,
                              close: _closeSearchPage,
                            ))
                        .toList());
                break;
              case ConnectionState.done:
                List lines = snapshot.data ?? [];
                List results = lines
                        .where((a) =>
                            a['name']
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            a['number']
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<BusLineCard>((a) => BusLineCard(
                              line: a,
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
    // TODO: implement buildSuggestions
    void _closeSearchPage(Map<String, dynamic> passBackData) {
      close(context, passBackData);
    }

    return StreamBuilder<List>(
        initialData: [],
        stream: routesStream, // stream data to listen for change
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
                List lines = snapshot.data ?? [];
                List results = lines
                        .where((a) =>
                            a['name']
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            a['number']
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<BusLineCard>((a) => BusLineCard(
                              line: a,
                              close: _closeSearchPage,
                            ))
                        .toList());
                break;
              case ConnectionState.done:
                List lines = snapshot.data ?? [];
                List results = lines
                        .where((a) =>
                            a['name']
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            a['number']
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<BusLineCard>((a) => BusLineCard(
                              line: a,
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
