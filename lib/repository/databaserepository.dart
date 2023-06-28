import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier{

  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //This method wraps the findAllTodos() method of the DAO
  Future<List<Diaryentry>> findAllEntries() async{
    final results = await database.diaryentryDao.findAllEntries();
    return results;
  }//findAllTodos

  //This method wraps the findAllTodos() method of the DAO
  Future<List<String?>> findEntriesWhere(String date) async{
    final results = await database.diaryentryDao.findEntriesWhere(date);
    return results;
  }//findAllTodos


  Future<int?> howManyEntries()async {
    var results = await database.diaryentryDao.howManyEntries();
    return results;
  }//insertDiaryentry
  
  //This method wraps the insertDiaryentry() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertDiaryentry(Diaryentry diaryentry)async {
    await database.diaryentryDao.insertDiaryentry(diaryentry);
    notifyListeners();
  }//insertDiaryentry

  //This method wraps the deleteDiaryentry() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deleteDiaryentry(Diaryentry entry) async{
    await database.diaryentryDao.deleteDiaryentry(entry);
    notifyListeners();
  }//deleteDiaryentry
  
}//DatabaseRepository