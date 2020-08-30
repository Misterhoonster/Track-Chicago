import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:track_chicago/models/bus_stop_data.dart';
import 'package:track_chicago/models/train_stop_data.dart';
import 'package:track_chicago/screens/bus_screen.dart';
import 'package:track_chicago/screens/train_screen.dart';

BusScreen busScreen = BusScreen();
TrainScreen trainScreen = TrainScreen();

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Widget> _children = [
    TrainScreen(),
    BusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        children: _children,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Color(0xFFC0C0C0),
          height: 55.0,
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
            tabs: <Widget>[
              Tab(
                icon: ImageIcon(
                  AssetImage('assets/icons/tracks.png'),
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.directions_bus,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
