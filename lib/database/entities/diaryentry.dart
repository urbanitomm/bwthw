import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class Diaryentry {
  //Date of entry as primary key
  @primaryKey
  final String date; 
  
  //Content of the diary entry
  final String entry;
  //Mood of the entry
  final String mood;

  //Default constructor
  Diaryentry(this.date, this.entry, this.mood);
  
}//DiaryEntry

