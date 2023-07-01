import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class Report {
  //Date of the report as the primarykey
  @primaryKey
  final String date;

  //Content of the report
  final String content;

  //Default constructor
  Report(this.date, this.content);
}//Report