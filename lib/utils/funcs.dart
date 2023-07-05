import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//String conversion format
const String stringFormat = 'yyyy-MM-dd';

String getYesterdayDate() {
  //Get yesterday's date
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(Duration(days: 1));
  //Format yesterday's date
  String formattedDate = DateFormat(stringFormat).format(yesterday);
  return formattedDate;
}

String getTodayDate() {
  //Get yesterday's date
  DateTime now = DateTime.now();
  //Format yesterday's date
  String formattedDate = DateFormat(stringFormat).format(now);
  return formattedDate;
}

DateTime stringToDate(String stringDate) {
  //Conversion from String to DateTime
  final parsedDate = DateTime.parse(stringDate);
  return parsedDate;
}

String dateToString(DateTime date) {
  //Conversion from DateTime to String
  final stringDate = DateFormat(stringFormat).format(date);
  return stringDate;
}

double dateTimeToDouble(DateTime dateTime) {
  return dateTime.millisecondsSinceEpoch / 1000;
}

double timeStringToDouble(String? timeString) {
  if (timeString == null) {
    return 90000;
  }
  List<String> components = timeString.split(':');
  if (components.length != 3) {
    return 0;
  }
  int hours = int.tryParse(components[0]) ?? 0;
  int minutes = int.tryParse(components[1]) ?? 0;
  int seconds = int.tryParse(components[2]) ?? 0;
  return (hours * 3600 + minutes * 60 + seconds).toDouble();
}

String doubleToString(double? timeDouble) {
  if (timeDouble == null) {
    return 'the input is null';
  }
  int totalSeconds = timeDouble.toInt();

  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds % 3600) ~/ 60;
  int seconds = totalSeconds % 60;

  String hoursString = hours.toString().padLeft(2, '0');
  String minutesString = minutes.toString().padLeft(2, '0');
  String secondsString = seconds.toString().padLeft(2, '0');

  return '$hoursString:$minutesString:$secondsString';
}

call(String celln) async {
  final cellurl = Uri.parse("tel://$celln");
  if (await canLaunchUrl(cellurl)) {
    launchUrl(cellurl);
  } else {
    throw 'Could not launch $cellurl';
  }
}
