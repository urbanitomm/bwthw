import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:progetto_wearable/database/entities/report.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //DIARYENTRY
  //This method wraps the findAllDiaryentries() method of the DAO
  Future<List<Diaryentry>> findAllEntries() async {
    final results = await database.diaryentryDao.findAllEntries();
    return results;
  } //findAllDiaryentries

  //This method wraps the findEntriesWhere() method of the DAO
  Future<List<String?>> findEntriesWhere(String date) async {
    final results = await database.diaryentryDao.findEntriesWhere(date);
    return results;
  } //findEntriesWhere

  //This method wraps the howManyEntries() method of the DAO
  Future<int?> howManyEntries() async {
    var results = await database.diaryentryDao.howManyEntries();
    return results;
  } //howManyEntries

  //This method wraps the insertDiaryentry() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertDiaryentry(Diaryentry diaryentry) async {
    await database.diaryentryDao.insertDiaryentry(diaryentry);
    notifyListeners();
  } //insertDiaryentry

  //This method wraps the deleteDiaryentry() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> deleteDiaryentry(Diaryentry entry) async {
    await database.diaryentryDao.deleteDiaryentry(entry);
    notifyListeners();
  } //deleteDiaryentry

/*
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
  } //howManyEntries*/
} //DatabaseRepository
