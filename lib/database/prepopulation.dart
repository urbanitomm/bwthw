import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/repository/databaseRepository.dart';
import 'package:progetto_wearable/repository/providerDataBaseSR.dart';
import 'package:progetto_wearable/database/entities/report.dart';

final DateTime firstDate = DateTime.now();
final String formattedDate = dateToString(firstDate);
//This long entry shows that the calendar can show entries of any lenght

//Prepopulation of the database at the first start of the app
prepopulate(BuildContext context) async {
  //Entry 1
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -13))),
          "Today I'm very sad",
          'Sad'));

  //Entry 2
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -12))),
          "Ok",
          'Neutral'));

  await Provider.of<SelfReportProvider>(context, listen: false).insertReport(
      Report(dateToString(firstDate.add(const Duration(days: -12))),
          'two drinks \n at home \n yesterday night'));

  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -11))),
          'Good',
          'Happy'));
  //Entry 3
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -10))),
          'good day',
          'Happy'));
  //Entry 4
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -9))),
          "Feeling kinda cranky",
          'Sad'));
  await Provider.of<SelfReportProvider>(context, listen: false).insertReport(
      Report(dateToString(firstDate.add(const Duration(days: -9))),
          'much alcohol \n at the bar \n yesterday afternoon'));
  //Entry 5
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -8))),
          "Slept very well",
          'Happy'));
  //Entry 6
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -7))),
          "Could be worse",
          'Neutral'));

  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -6))),
          "Not so good today",
          'Neutral'));

  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -5))),
          "Unhappy",
          'Sad'));

  //Entry 7
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -4))),
          "It's ok",
          'Neutral'));
  await Provider.of<SelfReportProvider>(context, listen: false).insertReport(
      Report(dateToString(firstDate.add(const Duration(days: -4))),
          'nothing but really would like it \n at home \n yesterday night'));
  //Entry 8
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -3))),
          "Feeling goooood",
          'Happy'));
  //Entry 9
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -2))),
          "Relaxed and refreshed",
          'Happy'));
  //Entry 10
  await Provider.of<DatabaseRepository>(context, listen: false)
      .insertDiaryentry(Diaryentry(
          dateToString(firstDate.add(const Duration(days: -1))),
          "Very sad",
          'Sad'));
  await Provider.of<SelfReportProvider>(context, listen: false).insertReport(
      Report(dateToString(firstDate.add(const Duration(days: -1))),
          'a bottle of wine \n at home \n yesterday night'));
}
