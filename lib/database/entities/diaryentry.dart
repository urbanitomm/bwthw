import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class Diaryentry {
  @primaryKey
  final String date; 

  //For the sake of simplicity, a Todo has only a name.
  final String entry;

  final String mood;

  //Default constructor
  Diaryentry(this.date, this.entry, this.mood);
  
}//Todo

