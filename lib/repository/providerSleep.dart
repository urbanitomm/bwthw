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

  //This method wraps the findEfficiency() method of the DAO
  Future<double?> findEfficiency(String date) async {
    final results = await database.sleepDao.findEfficiency(date);
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