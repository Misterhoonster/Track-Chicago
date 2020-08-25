import 'package:flutter/material.dart';
import 'package:track_chicago/models/flushbars.dart';

import 'package:track_chicago/widgets/bus_arrival_card.dart';
import 'package:track_chicago/widgets/train_arrival_card.dart';

class ArrivalListTile extends StatelessWidget {
  const ArrivalListTile(
      {this.data, this.index, this.key, this.listContext, this.isTrain});

  final dynamic data;
  final int index;
  final Key key;
  final BuildContext listContext;
  final bool isTrain;

  @override
  Widget build(BuildContext context) {
    dynamic currentStop = data.stops[index];
    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Remove the item from the data source.
        data.removeStop(index);
        // Then show a snackbar.
        displayRemovedFlushbar(
            context: listContext,
            stop: currentStop,
            index: index,
            isTrain: isTrain);
      },
      // Show a red background as the item is swiped away.
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
      child: isTrain
          ? TrainArrivalCard(
              name: currentStop.name,
              direction: currentStop.direction,
              arrivalTimes: currentStop.arrivalTimes,
              color: currentStop.color,
            )
          : BusArrivalCard(
              name: currentStop.name,
              route: currentStop.route,
              direction: currentStop.direction,
              arrivalTimes: currentStop.arrivalTimes,
            ),
    );
  }
}
