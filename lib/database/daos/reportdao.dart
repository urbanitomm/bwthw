import 'package:progetto_wearable/database/entities/report.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class ReportDao {

  //Query #1: SELECT ALL-> this allows to obtain all the reports of the Report table
  @Query('SELECT * FROM Report')
  Future<List<Report>> findAllReports();

  //Query #2: INSERT -> this allows to add a Report in the table
  @insert
  Future<void> insertReport(Report report);

  //Query #3: DELETE -> this allows to delete a Report from the table
  @delete
  Future<void> deleteReport(Report report);

  //Query #5: COUNT-> this allows to obtain the number of entries
  @Query('SELECT COUNT(*) FROM Diaryentry')
  Future<int?> howManyReports();

}//ReportDao