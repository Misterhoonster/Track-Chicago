import 'package:flutter/material.dart';

import 'package:track_chicago/constants.dart';
import 'package:track_chicago/widgets/bus_arrival_time.dart';

class BusArrivalCard extends StatefulWidget {
  final String name;
  final String direction;
  final String route;
  final List<String> arrivalTimes;

  BusArrivalCard(
      {@required this.name,
      @required this.direction,
      @required this.route,
      @required this.arrivalTimes});

  @override
  _BusArrivalCardState createState() => _BusArrivalCardState();
}

class _BusArrivalCardState extends State<BusArrivalCard>
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

    //TODO: make corners of the container transparent
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
        margin: EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          border: Border.all(color: busBlue, width: 4.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: <Widget>[
                        Text(
                          this.widget.route,
                          style: busNumberTextStyle,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  this.widget.name,
                                  style: busTitleTextStyle,
                                ),
                                Text(
                                  this.widget.direction,
                                  style: busSubtitleTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: BusArrivalTime(this.widget.arrivalTimes[0]),
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
            color: busBlue,
            fontSize: 20.0,
          ),
        ),
        Text(
          'min',
          style: TextStyle(
            color: busBlue,
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}
