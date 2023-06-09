import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/database/entities/HRentity.dart';
import 'package:flutter/material.dart';

class ProviderHR extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  ProviderHR({required this.database});

  //HRENTRY
  //This method wraps the findAllDiaryentries() method of the DAO
  Future<List<HREntity>> findAllHR() async {
    final results = await database.hRdao.findAllHR();
    return results;
  } //findAllDiaryentries

  Future<List<HREntity>> findDateEntry(String date) async {
    final results = await database.hRdao.findDateEntry(date);
    return results;
  } //findDateEntry

  //This method wraps the findEntriesWhere() method of the DAO
  Future<List<int?>> findEntriesAfter(String date, double time) async {
    final results = await database.hRdao.findEntriesAfter(date, time);
    return results;
  } //findEntriesWhere

  //This method wraps the findEntriesBetween() method of the DAO
  Future<List<int?>> findEntriesBetween(
      String date, double time1, double time2) async {
    final results = await database.hRdao.findEntriesBetween(date, time1, time2);
    return results;
  }

  //This method wraps the howManyEntries() method of the DAO
  Future<List<int?>> findEntriesBefore(String date, double time) async {
    final results = await database.hRdao.findEntriesBefore(date, time);
    return results;
  } //howManyEntries

  //This method wraps the insertDiaryentry() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertHR(HREntity hrentity) async {
    await database.hRdao.insertHR(hrentity);
    notifyListeners();
  } //insertDiaryentry

  //This method wraps the insertMultipleDiaryentries() method of the DAO.
  Future<void> insertMultipleHR(List<HREntity> hrentity) async {
    await database.hRdao.insertMultipleHR(hrentity);
    notifyListeners();
  } //insertMultipleDiaryentries

  //This method wraps the deleteDiaryentry() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> deleteHR(HREntity hrentity) async {
    await database.hRdao.deleteHR(hrentity);
    notifyListeners();
  }

  //This method wraps the howManyEntries() method of the DAO
  Future<int?> howManyHR() async {
    var results = await database.hRdao.howManyHR();
    return results;
  }
}//deleteDiaryentry