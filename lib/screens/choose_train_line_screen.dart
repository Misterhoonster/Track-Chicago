import 'package:flutter/material.dart';
import 'package:track_chicago/constants.dart';
import 'package:track_chicago/models/train_line.dart';
import 'package:track_chicago/widgets/train_line_card.dart';

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
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            List<TrainLine> line = data[index];
            return TrainLineCard(
              lines: line,
            );
          },
        ),
      ),
    );
  }
}
