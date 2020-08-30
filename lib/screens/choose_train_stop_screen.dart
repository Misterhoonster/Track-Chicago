import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/models/train_line.dart';
import 'package:track_chicago/widgets/train_stop_card.dart';
import 'package:track_chicago/models/networking.dart';

class TrainStopScreen extends StatelessWidget {
  final TrainLine line;

  TrainStopScreen(this.line);

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
                  Map<String, dynamic> passBackData = await showSearch(
                    context: context,
                    delegate:
                        TrainStopSearch(Networking().getTrainStopsStream(line)),
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
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: BuildStopsList(line),
      ),
    );
  }
}

class BuildStopsList extends StatelessWidget {
  const BuildStopsList(this.line);

  final TrainLine line;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: line.stops.length,
      itemBuilder: (context, index) {
        Map stop = {"name": line.stops[index], "index": index};
        return TrainStopCard(
          stop: stop,
          line: line,
        );
      },
    );
  }
}

class TrainStopSearch extends SearchDelegate<Map<String, dynamic>> {
  final Stream<TrainLine> stopsStream;

  TrainStopSearch(this.stopsStream);

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
    return StreamBuilder<TrainLine>(
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
                TrainLine line = snapshot.data;
                List<String> stops = snapshot.data.stops ?? [];
                List<Map> stopsList = [];

                for (int i = 0; i < stops.length; i++) {
                  stopsList.add({
                    "name": stops[i],
                    "index": i,
                  });
                }

                List<Map> results = stopsList
                        .where((a) => a["name"]
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<TrainStopCard>((a) => TrainStopCard(
                              stop: a,
                              line: line,
                              close: _closeSearchPage,
                            ))
                        .toList());
                break;
              case ConnectionState.done:
                TrainLine line = snapshot.data;
                List<String> stops = snapshot.data.stops ?? [];
                List<Map> stopsList = [];

                for (int i = 0; i < stops.length; i++) {
                  stopsList.add({
                    "name": stops[i],
                    "index": i,
                  });
                }

                List<Map> results = stopsList
                        .where((a) => a["name"]
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<TrainStopCard>((a) => TrainStopCard(
                              stop: a,
                              line: line,
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
    return StreamBuilder<TrainLine>(
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
                TrainLine line = snapshot.data;
                List<String> stops = snapshot.data.stops ?? [];
                List<Map> stopsList = [];

                for (int i = 0; i < stops.length; i++) {
                  stopsList.add({
                    "name": stops[i],
                    "index": i,
                  });
                }

                List<Map> results = stopsList
                        .where((a) => a["name"]
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<TrainStopCard>((a) => TrainStopCard(
                              stop: a,
                              line: line,
                              close: _closeSearchPage,
                            ))
                        .toList());
                break;
              case ConnectionState.done:
                TrainLine line = snapshot.data;
                List<String> stops = snapshot.data.stops ?? [];
                List<Map> stopsList = [];

                for (int i = 0; i < stops.length; i++) {
                  stopsList.add({
                    "name": stops[i],
                    "index": i,
                  });
                }

                List<Map> results = stopsList
                        .where((a) => a["name"]
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<TrainStopCard>((a) => TrainStopCard(
                              stop: a,
                              line: line,
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
