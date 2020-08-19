class BusStop {
  final String name;
  final String direction;
  final String stopID;
  final String route;
  List<String> arrivalTimes;

  BusStop(
      {this.name, this.direction, this.stopID, this.route, this.arrivalTimes});

  BusStop.fromMap(Map<String, dynamic> map)
      : this.name = map['name'],
        this.direction = map['direction'],
        this.stopID = map['stopID'],
        this.route = map['route'],
        this.arrivalTimes = map['arrivalTimes'].split(" ");

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'direction': direction,
      'stopID': stopID,
      'route': route,
      'arrivalTimes': arrivalTimes.join(' '),
    };
  }
}
