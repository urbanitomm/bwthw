import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class Sleepentry {
  @primaryKey
  final String? date;

  final double? startTime;

  final double? endTime;

  final double? duration;

  final double? efficiency;

  //Default constructor
  Sleepentry(
      this.date, this.startTime, this.endTime, this.duration, this.efficiency);
}//Todo
