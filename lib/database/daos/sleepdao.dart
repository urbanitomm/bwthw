import 'package:progetto_wearable/database/entities/sleepentry.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class SleepDao {
  //Query #1: SELECT ALL-> this allows to obtain all the reports of the Sleep table
  @Query('SELECT * FROM Sleepentry')
  Future<List<Sleepentry>> findAllSleep();

  //Query #2: SELECT WHERE-> this allows to obtain the startTime of the Sleep table
  //from a specific date
  @Query('SELECT startTime FROM Sleepentry WHERE (date = :date) ')
  Future<double?> findStartTime(String date);

  //Query #3: SELECT WHERE-> this allows to obtain the endTime of the Sleep table
  //from a specific date
  @Query('SELECT endTime FROM Sleepentry WHERE (date = :date)')
  Future<double?> findEndTime(String date);

  //Query #4: SELECT WHERE-> this allows to obtain the duration of the Sleep table
  //from a specific date
  @Query('SELECT duration FROM Sleepentry WHERE (date = :date)')
  Future<double?> findDuration(String date);

  //Query #4: SELECT WHERE-> this allows to obtain the efficiency of the Sleep table
  //from a specific date
  @Query('SELECT efficiency FROM Sleepentry WHERE (date = :date)')
  Future<double?> findEfficiency(String date);

  //Query #4: INSERT -> this allows to add a Sleepentry in the table
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSleep(Sleepentry sleepentry);

  //Query #4: INSERT -> this allows to add a list of Sleepentry in the table
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMultiSleep(List<Sleepentry> sleepentry);

  //Query #5: DELETE -> this allows to delete a Sleepentry from the table
  @delete
  Future<void> deleteSleep(Sleepentry sleepentry);

  //Query #6: COUNT-> this allows to obtain the number of Sleepentry
  @Query('SELECT COUNT(*) FROM Sleepentry')
  Future<int?> howManySleep();
} //ReportDao
