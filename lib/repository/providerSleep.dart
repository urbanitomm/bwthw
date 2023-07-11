import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/database/entities/sleepentry.dart';
import 'package:flutter/material.dart';

class ProviderSleep extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  ProviderSleep({required this.database});

  //SleepENTRY
  //This method wraps the findAllSleep() method of the DAO
  Future<List<Sleepentry>> findAllSleep() async {
    final results = await database.sleepDao.findAllSleep();
    return results;
  } //findAllDiaryentries

  //This method wraps the findDateSleep() method of the DAO
  Future<Sleepentry?> findDateSleep(String date) async {
    final results = await database.sleepDao.findDateSleep(date);
    return results;
  } //findAllDiaryentries

  //This method wraps the findStartTime() method of the DAO
  Future<double?> findStartTime(String date) async {
    final results = await database.sleepDao.findStartTime(date);
    return results;
  }

  //This method wraps the findEndTime() method of the DAO
  Future<double?> findEndTime(String date) async {
    final results = await database.sleepDao.findEndTime(date);
    return results;
  }

  //This method wraps the findDuration() method of the DAO
  Future<double?> findDuration(String date) async {
    final results = await database.sleepDao.findDuration(date);
    return results;
  }

  //This method wraps the findWeekDuration() method of the DAO
  Future<List<double?>?> findWeekDuration(
      String date1,
      String date2,
      String date3,
      String date4,
      String date5,
      String date6,
      String date7) async {
    final results = await database.sleepDao
        .findWeekDuration(date1, date2, date3, date4, date5, date6, date7);
    return results;
  }

  //This method wraps the findEfficiency() method of the DAO
  Future<double?> findEfficiency(String date) async {
    final results = await database.sleepDao.findEfficiency(date);
    return results;
  }

  //This method wraps the findWeekEfficiency() method of the DAO
  Future<List<double?>?> findWeekEfficiency(
      String date1,
      String date2,
      String date3,
      String date4,
      String date5,
      String date6,
      String date7) async {
    final results = await database.sleepDao
        .findWeekEfficiency(date1, date2, date3, date4, date5, date6, date7);
    return results;
  }

  //This method wraps the insertSleep() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertSleep(Sleepentry sleepentry) async {
    await database.sleepDao.insertSleep(sleepentry);
    notifyListeners();
  }

  //This method wraps the insertMultiSleep() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertMultiSleep(List<Sleepentry> multisleepentry) async {
    await database.sleepDao.insertMultiSleep(multisleepentry);
    notifyListeners();
  }

  //This method wraps the deleteSleep() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> deleteSleep(Sleepentry sleepentry) async {
    await database.sleepDao.deleteSleep(sleepentry);
    notifyListeners();
  } //insertDiaryentry

  //This method wraps the howManySleep() method of the DAO
  Future<int?> howManySleep() async {
    var results = await database.sleepDao.howManySleep();
    return results;
  }
}//deleteDiaryentry