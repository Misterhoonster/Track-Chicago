import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_chicago/constants.dart';

import 'package:track_chicago/models/train_stop_data.dart';
import 'package:track_chicago/models/flushbars.dart';
import 'package:track_chicago/screens/choose_train_line_screen.dart';
import 'package:track_chicago/widgets/train_stops_list_view.dart';

// UNCOMMENT TO CHECK STOPS
// import 'package:track_chicago/models/networking.dart';
// import 'package:track_chicago/widgets/check_train_stops.dart';

class TrainScreen extends StatefulWidget {
  TrainScreen({Key key}) : super(key: key);

  @override
  _TrainScreenState createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  // UNCOMMENT TO CHECK STOPS
  // var badStops = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 45.0,
            left: 30.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'last updated',
                        style: lastUpdatedTextStyle,
                      ),
                      Text(
                        Provider.of<TrainStopData>(context).lastUpdated,
                        style: lastUpdatedTimeTextStyle,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Image.asset('assets/icons/plus button.png'),
                    onPressed: () async {
                      navigateAndDisplayFlushbar(context, TrainLineScreen());

                      //UNCOMMENT TO CHECK STOPS
                      // print('Button pressed');
                      // Networking networking = Networking();
                      // baddies = await networking.testTrainStopData();
                      // setState(() {});
                    },
                    color: Colors.grey,
                    iconSize: 50.0,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 15,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              child: TrainStopsListView(),
              //child: badStops.length < 0 ? CheckStops(badStops) : Container(),
            ),
          ),
        ),
      ],
    );
  }
}
