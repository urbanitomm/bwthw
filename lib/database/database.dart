//Imports that are necessary to the code generator of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:progetto_wearable/database/entities/report.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Here, we are importing the entities and the daos of the database
import 'daos/diaryentrydao.dart';
import 'daos/reportdao.dart';
import 'entities/diaryentry.dart';

 //The generated code will be in database.g.dart
part 'database.g.dart';

//Here we are saying that this is the first version of the Database
//It has 2 entities: Diaryentry and report
@Database(version: 1, entities: [Diaryentry, Report])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  DiaryentryDao get diaryentryDao;
  ReportDao get reportDao;
}//AppDatabase