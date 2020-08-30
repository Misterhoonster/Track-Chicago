import 'package:flutter/material.dart';
import 'package:track_chicago/constants.dart';
import 'package:track_chicago/models/train_line.dart';
import 'package:track_chicago/widgets/train_line_card.dart';
import 'choose_train_stop_screen.dart';
import 'package:track_chicago/models/networking.dart';

class TrainLineScreen extends StatelessWidget {
  final List<List<TrainLine>> data = TrainLineData().data;

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
                  TrainLine searchPassBack = await showSearch(
                    context: context,
                    delegate:
                        TrainLineSearch(Networking().getTrainLinesStream()),
                  );

                  if (searchPassBack != null) {
                    Map<String, dynamic> passBackData = await Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                      return TrainStopScreen(searchPassBack);
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
                  .getTrainLinesStream(), // stream data to listen for change
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
                      child = BuildLinesList(lines);
                      break;
                    case ConnectionState.done:
                      List lines = snapshot.data;
                      child = BuildLinesList(lines);
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

class BuildLinesList extends StatelessWidget {
  const BuildLinesList(this.data);

  final List data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        List<TrainLine> line = data[index];
        return TrainLineCard(
          line: line,
        );
      },
    );
  }
}

class TrainLineSearch extends SearchDelegate<TrainLine> {
  final Stream<List> linesStream;

  TrainLineSearch(this.linesStream);

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
    void _closeSearchPage(TrainLine passBackData) {
      close(context, passBackData);
    }

    // TODO: implement buildResults
    return StreamBuilder<List>(
        initialData: [],
        stream: linesStream, // stream data to listen for change
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
                        .where((a) => a[0]
                            .name
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<TrainLineCard>((a) => TrainLineCard(
                              line: a,
                            ))
                        .toList());
                break;
              case ConnectionState.done:
                List lines = snapshot.data ?? [];
                List results = lines
                        .where((a) => a[0]
                            .name
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<TrainLineCard>((a) => TrainLineCard(
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
    void _closeSearchPage(TrainLine passBackData) {
      close(context, passBackData);
    }

    return StreamBuilder<List>(
        initialData: [],
        stream: linesStream, // stream data to listen for change
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
                        .where((a) => a[0]
                            .name
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<TrainLineCard>((a) => TrainLineCard(
                              line: a,
                            ))
                        .toList());
                break;
              case ConnectionState.done:
                List lines = snapshot.data ?? [];
                List results = lines
                        .where((a) => a[0]
                            .name
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList() ??
                    [];
                child = ListView(
                    children: results
                        .map<TrainLineCard>((a) => TrainLineCard(
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
