import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class DiaryentryDao {

  //Query #1: SELECT ALL-> this allows to obtain all the entries of the Diaryentry table
  @Query('SELECT * FROM Diaryentry')
  Future<List<Diaryentry>> findAllEntries();

  //Query #2: SELECT WHERE-> this allows to obtain the entry of the Diaryentry table
  //from a specific date
  @Query('SELECT entry,mood FROM Diaryentry WHERE date = :date')
  Future<List<String?>> findEntriesWhere(String date);

  //Query #3: COUNT-> this allows to obtain the number of entries
  @Query('SELECT COUNT(*) FROM Diaryentry')
  Future<int?> howManyEntries();

  //Query #4: INSERT -> this allows to add a Diaryentry in the table
  @insert
  Future<void> insertDiaryentry(Diaryentry diaryentry);

  //Query #5: DELETE -> this allows to delete a Diaryentry from the table
  @delete
  Future<void> deleteDiaryentry(Diaryentry diaryentry);

}//DiaryentryDao