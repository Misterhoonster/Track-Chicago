import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:track_chicago/models/train_stop_data.dart';
import 'package:flushbar/flushbar.dart';
import 'bus_stop_data.dart';

// A method that launches the SelectionScreen and awaits the
// result from Navigator.pop.
void navigateAndDisplayFlushbar(BuildContext context, pushedScreen) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final result = await Navigator.push(
    context,
    // Create the SelectionScreen in the next step.
    MaterialPageRoute(builder: (context) => pushedScreen),
  );
  if (result != null) {
    if (result['success']) {
      Flushbar(
        message: '${result['name']} ${result['direction']} has been added.',
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        duration: Duration(
          seconds: 3,
        ),
        icon: Icon(
          Icons.check,
          color: Colors.greenAccent,
        ),
      )..show(context);
    } else {
      Flushbar(
        message:
            '${result['name']} ${result['direction']} has already been added.',
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        duration: Duration(
          seconds: 3,
        ),
        icon: Icon(
          Icons.error,
          color: Colors.yellowAccent,
        ),
      )..show(context);
    }
  }
}

void displayRemovedFlushbar(
    {BuildContext context, var stop, int index, bool isTrain}) {
  Flushbar flush;
  flush = Flushbar(
    message: '${stop.name} ${stop.direction} has been removed.',
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    duration: Duration(
      seconds: 3,
    ),
    icon: Icon(
      Icons.delete,
      color: Colors.redAccent,
    ),
    mainButton: FlatButton(
      onPressed: () {
        if (isTrain) {
          Provider.of<TrainStopData>(context, listen: false)
              .undoDelete(index: index, stop: stop);
        } else {
          Provider.of<BusStopData>(context, listen: false)
              .undoDelete(index: index, stop: stop);
        }
        flush.dismiss(true); // result = true
      },
      child: Text(
        "UNDO",
        style: TextStyle(color: Colors.amber),
      ),
    ),
  )..show(context);
}
