import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/widgets/train_arrival_time.dart';

class TrainArrivalCard extends StatefulWidget {
  final String name;
  final String direction;
  final List<String> arrivalTimes;
  final Color color;

  TrainArrivalCard(
      {@required this.name,
      @required this.direction,
      @required this.arrivalTimes,
      @required this.color});

  @override
  _TrainArrivalCardState createState() => _TrainArrivalCardState();
}

class _TrainArrivalCardState extends State<TrainArrivalCard>
    with SingleTickerProviderStateMixin {
  bool expandedHeight = false;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> timeRowBuilder() {
      if (widget.arrivalTimes.sublist(1) != null) {
        return widget.arrivalTimes.sublist(1).map((time) {
          return TimeColumn(time);
        }).toList();
      } else {
        return <Widget>[];
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          expandedHeight = !expandedHeight;
          if (expandedHeight) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: this.widget.color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.symmetric(
          vertical: 6.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          this.widget.name,
                          style: cardTitleTextStyle,
                        ),
                        Text(this.widget.direction,
                            style: cardSubtitleTextStyle),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child:
                        TrainArrivalTime(widget.arrivalTimes[0], widget.color),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _controller,
              child: Container(
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Divider(
                      height: 5.0,
                      thickness: 1.0,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: timeRowBuilder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeColumn extends StatelessWidget {
  final String time;
  TimeColumn(this.time);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          time,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        Text(
          'min',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}
