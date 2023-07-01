import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/database/entities/report.dart';
import 'package:flutter/material.dart';

class SelfReportProvider extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  SelfReportProvider({required this.database});

  //REPORT
  //This method wraps the howManyEntries() method of the DAO
  Future<List<Report>> findAllReports() async {
    final results = await database.reportDao.findAllReports();
    return results;
  } //findAllReports

  //This method wraps the insertDiaryentry() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertReport(Report report) async {
    await database.reportDao.insertReport(report);
    notifyListeners();
  } //insertReport

  //This method wraps the deleteDiaryentry() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> deleteReport(Report report) async {
    await database.reportDao.deleteReport(report);
    notifyListeners();
  } //deleteReport

  //This method wraps the howManyEntries() method of the DAO
  Future<int?> howManyReports() async {
    var results = await database.reportDao.howManyReports();
    return results;
  } //howManyEntries
} //DatabaseRepository
