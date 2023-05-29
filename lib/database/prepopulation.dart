import 'package:floor/floor.dart';
import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/daos/diaryentrydao.dart';
import 'package:progetto_wearable/repository/databaseRepository.dart';
import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/main.dart';
import 'package:intl/intl.dart';

final DateTime firstDate = DateTime.now();
final String formattedDate = dateToString(firstDate);
//Serve per mostrare la capacità di mostrare testi lunghi
const String loremIpsum = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In volutpat mauris id dictum laoreet. Ut elementum ex ut nisi ornare pretium. In interdum odio lectus. Phasellus posuere urna at dolor gravida, volutpat luctus sem tincidunt. Proin sodales aliquet porta. Integer et vulputate lectus. Maecenas at nulla ac urna sollicitudin ullamcorper. Curabitur et convallis dolor. Suspendisse ac tortor fermentum, blandit justo pellentesque, interdum ante. Vestibulum elit orci, venenatis pellentesque orci a, volutpat fringilla nibh. Cras et enim est. Ut sit amet maximus arcu. Nunc bibendum hendrerit enim, sed venenatis justo feugiat ac. Sed pharetra eu ipsum id sagittis. Morbi vel nunc tellus. Etiam feugiat quis urna at bibendum. Praesent eget lectus accumsan, aliquet neque ac, gravida lorem. In massa lacus, sagittis vitae ultrices feugiat, hendrerit eu eros. Ut ac velit tempor, rhoncus augue sit amet, pretium purus. Proin quam nibh, aliquam at nulla ut, luctus porta nulla. Ut posuere mollis dui et ornare. Sed fringilla finibus neque lobortis tempor. Cras quis tincidunt libero. Morbi dapibus tristique aliquam. Nam aliquet aliquet augue eu dignissim. In hac habitasse platea dictumst. Proin nec diam nibh. Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque ornare urna ipsum, ac tempor nunc fringilla vel. Suspendisse a nulla eu mi euismod lacinia.Vivamus quis metus eros. Duis ut enim vitae nulla auctor gravida a dignissim mi. Integer libero magna, convallis sit amet tincidunt quis, molestie id mi. Nulla tempus leo eget elit tempor, a aliquet sapien fermentum. Aenean non tempor purus, vel accumsan neque. Nulla placerat gravida odio, vitae commodo nisl lacinia a. Vivamus eu magna lacus. Morbi velit dui, commodo vel consequat nec, ornare eget libero. Duis egestas fringilla luctus. Maecenas ultrices blandit nisl, id feugiat leo accumsan vel. Quisque risus massa, venenatis bibendum metus nec, tempus varius arcu. Curabitur suscipit pulvinar mauris et dapibus. ';

prepopulate(BuildContext context) async{

  //Entry 1
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -13))),"Today I'm very sad", 'Sad'));
  print('1');
  //Entry 2
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -12))),"Ok", 'Neutral'));
  print('7');
  //Entry 3
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -10))),loremIpsum, 'Happy'));
  //Entry 4
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -9))),"Feeling kinda cranky", 'Sad'));
  //Entry 5
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -8))),"Slept very well", 'Happy'));
  //Entry 6
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -7))),"Could be worse", 'Neutral'));
  //Entry 7
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -4))),"It's ok", 'Neutral'));
  //Entry 8
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -3))),"Feeling goooood", 'Happy'));
  //Entry 9
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -2))),"Relaxed and refreshed", 'Happy'));
  print('55');
  //Entry 10
  await Provider.of<DatabaseRepository>(context, listen: false).insertDiaryentry(
    Diaryentry(dateToString(firstDate.add(const Duration(days: -1))),"Very sad", 'Sad'));
  
}

//Future<void> insertDiaryentry(Diaryentry diaryentry);

//DateTime.parse(consideredEntry.date),