import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:reorderables/reorderables.dart';

import 'package:track_chicago/models/train_stop_data.dart';
import 'package:track_chicago/widgets/arrival_list_tile.dart';
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
    _refreshController = RefreshController(initialRefresh: false);
  }

  List<Widget> buildListView(TrainStopData stopData, BuildContext listContext) {
    List<Widget> tiles = [];
    stopData.stops.asMap().forEach((index, stop) {
      tiles.add(
        ArrivalListTile(
          data: stopData,
          index: index,
          key: UniqueKey(),
          listContext: listContext,
          isTrain: true,
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
                        buildListView(stopData, context)),
                    onReorder: (int oldIndex, int newIndex) {
                      stopData.reorderStops(oldIndex, newIndex);
                    },
                    buildDraggableFeedback: (BuildContext context,
                        BoxConstraints constraints, Widget child) {
                      return Transform(
                        transform: Matrix4.rotationZ(0),
                        alignment: FractionalOffset.topLeft,
                        child: Material(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: ConstrainedBox(
                                  constraints: constraints, child: child)),
                          elevation: 0.0,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.zero,
                        ),
                      );
                    },
                  ),
                ],
              ),
      );
    });
  }
}
