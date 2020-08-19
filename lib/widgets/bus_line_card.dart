import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/screens/choose_bus_stop.dart';

class BusLineCard extends StatelessWidget {
  final Map<String, dynamic> line;
  final Function close;

  BusLineCard({this.line, this.close});

  @override
  Widget build(BuildContext context) {
    List<Widget> buildTiles() {
      List<Widget> tiles = [];
      for (var i = 0; i < line['directions'].length; i++) {
        tiles.add(LineTile(line: line, index: i, close: close));
      }
      return tiles;
    }

    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: busBlue, width: 4.0),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            leading: Text(
              line['number'],
              style: busNumberTextStyle,
            ),
            title: Text(
              line['name'],
              style: busTitleTextStyle,
            ),
          ),
          ...buildTiles(),
        ],
      ),
    );
  }
}

class LineTile extends StatelessWidget {
  LineTile({this.line, this.index, this.close});

  final Map<String, dynamic> line;
  final int index;
  final Function close;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          thickness: 1.0,
          height: 0.0,
        ),
        GestureDetector(
          onTap: () async {
            if (close != null) {
              Map<String, dynamic> searchPassBack = {
                'direction': line['directions'][index],
                'route': line['number'],
              };

              close(searchPassBack);
            } else {
              Map<String, dynamic> passBackData = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return BusStopScreen(
                  direction: line['directions'][index],
                  route: line['number'],
                );
              }));
              Navigator.pop(context, passBackData);
            }
          },
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 15.0),
            title: Text(
              line['directions'][index],
              style: busSubtitleTextStyle,
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: busBlue,
                size: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
