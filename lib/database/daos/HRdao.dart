import 'package:progetto_wearable/database/entities/HRentity.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class HRdao {
  //Query #1: SELECT ALL-> this allows to obtain all the reports of the HR table
  @Query('SELECT * FROM HREntity')
  Future<List<HREntity>> findAllHR();

  @Query('SELECT * FROM HREntity WHERE (date = :date)')
  Future<List<HREntity>> findDateEntry(String date);

  //Query #2: SELECT WHERE-> this allows to obtain the value of the HR table
  //from a specific date and after a specific moment in time
  @Query('SELECT value FROM HREntity WHERE (date = :date) AND (time >= :time)')
  Future<List<int?>> findEntriesAfter(String date, double time);

  //Query #2: SELECT WHERE-> this allows to obtain the value of the HR table
  //from a specific date and after a specific moment in time
  @Query(
      'SELECT value FROM HREntity WHERE (date = :date) AND (time >= :time1) AND (time <= :time2)')
  Future<List<int?>> findEntriesBetween(
      String date, double time1, double time2);

  //Query #3: SELECT WHERE-> this allows to obtain the value of the HR table
  //from a specific date and before a specific moment in time
  @Query('SELECT value FROM HREntity WHERE (date = :date) AND (time <= :time)')
  Future<List<int?>> findEntriesBefore(String date, double time);

  //Query #4: INSERT -> this allows to add a HR in the table
  @insert
  Future<void> insertHR(HREntity hrentity);

  //Query #4: INSERT -> this allows to add multiple  HR in the table
  @insert
  Future<void> insertMultipleHR(List<HREntity> hrentity);

  //Query #5: DELETE -> this allows to delete a HR from the table
  @delete
  Future<void> deleteHR(HREntity hrentity);

  //Query #6: COUNT-> this allows to obtain the number of entries
  @Query('SELECT COUNT(*) FROM HREntity')
  Future<int?> howManyHR();
} //ReportDao
