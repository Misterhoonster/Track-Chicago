import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:reorderables/reorderables.dart';

import 'package:track_chicago/models/train_stop_data.dart';
import 'package:track_chicago/models/flushbars.dart';
import 'package:track_chicago/models/train_stop.dart';
import 'package:track_chicago/widgets/train_arrival_card.dart';
import 'package:track_chicago/constants.dart';

class TrainStopsListView extends StatefulWidget {
  @override
  _TrainStopsListViewState createState() => _TrainStopsListViewState();
}

class _TrainStopsListViewState extends State<TrainStopsListView> {
  RefreshController _refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  List<Widget> buildListView(TrainStopData stopData) {
    List<Widget> tiles = [];
    stopData.stops.asMap().forEach((index, stop) {
      tiles.add(
        ArrivalListTile(
          data: stopData,
          index: index,
          key: UniqueKey(),
        ),
      );
    });
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainStopData>(builder: (context, stopData, child) {
      ScrollController _scrollController =
          PrimaryScrollController.of(context) ?? ScrollController();

      return SmartRefresher(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          await Provider.of<TrainStopData>(context, listen: false)
              .refreshStops();
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          _refreshController.loadComplete();
        },
        controller: _refreshController,
        header: ClassicHeader(
          idleText: 'pull to refresh',
          releaseText: 'release to refresh',
          refreshingText: 'refreshing',
          completeText: 'refresh completed',
        ),
        footer: ClassicFooter(),
        child: stopData.stops.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'click',
                          style: lastUpdatedTimeTextStyle.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        IconButton(
                          icon: Image.asset('assets/icons/plus button.png'),
                          iconSize: 20.0,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Text(
                      'to add train stop',
                      style: lastUpdatedTimeTextStyle.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  ReorderableSliverList(
                    delegate: ReorderableSliverChildListDelegate(
                        buildListView(stopData)),
                    onReorder: (int oldIndex, int newIndex) {
                      stopData.reorderStops(oldIndex, newIndex);
                    },
                  ),
                ],
              ),
      );
    });
  }
}

class ArrivalListTile extends StatelessWidget {
  const ArrivalListTile({this.data, this.index, this.key});

  final TrainStopData data;
  final int index;
  final Key key;

  @override
  Widget build(BuildContext context) {
    TrainStop currentStop = data.stops[index];
    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Remove the item from the data source.
        data.removeStop(index);
        // Then show a snackbar.
        displayRemovedFlushbar(
            context: context, stop: currentStop, index: index, isTrain: true);
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
      child: TrainArrivalCard(
        name: currentStop.name,
        direction: currentStop.direction,
        arrivalTimes: currentStop.arrivalTimes,
        color: currentStop.color,
      ),
    );
  }
}
