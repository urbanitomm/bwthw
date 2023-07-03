import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//String conversion format
const String stringFormat = 'yyyy-MM-dd';

String getTodayDate() {
  //Format today's date
  DateTime now = DateTime.now();
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

double timeStringToDouble(String timeString) {
  List<String> components = timeString.split(':');
  if (components.length != 3) {
    return 0;
  }
  int hours = int.tryParse(components[0]) ?? 0;
  int minutes = int.tryParse(components[1]) ?? 0;
  int seconds = int.tryParse(components[2]) ?? 0;
  return (hours * 3600 + minutes * 60 + seconds).toDouble();
}

call(String celln) async {
  final cellurl = Uri.parse("tel://$celln");
  if (await canLaunchUrl(cellurl)) {
    launchUrl(cellurl);
  } else {
    throw 'Could not launch $cellurl';
  }
}
