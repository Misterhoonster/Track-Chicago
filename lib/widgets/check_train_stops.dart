import 'package:flutter/material.dart';

class CheckStops extends StatelessWidget {
  final List badStops;

  CheckStops(this.badStops);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'incorrect stopIDs:',
        ),
        Expanded(
          child: ListView.builder(
              itemCount: badStops[0].length,
              itemBuilder: (context, index) {
                var stop = badStops[0][index];
                return ListTile(
                  title: Text(stop['name'].toString()),
                  subtitle: Text(stop['rt'].toString()),
                  trailing: Text(stop['stopID'].toString()),
                );
              }),
        ),
        Text('no data:'),
        Expanded(
          child: ListView.builder(
              itemCount: badStops[1].length,
              itemBuilder: (context, index) {
                var stop = badStops[1][index];
                return ListTile(
                  title: Text(stop['name'].toString()),
                  subtitle: Text(stop['rt'].toString()),
                  trailing: Text(stop['stopID'].toString()),
                );
              }),
        ),
      ],
    );
  }
}
