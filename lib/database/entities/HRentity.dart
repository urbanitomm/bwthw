import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class HREntity {
  @primaryKey
  final String date;

  //For the sake of simplicity, a Todo has only a name.
  final double time;

  final int value;

  //Default constructor
  HREntity(this.date, this.time, this.value);
}//Todo