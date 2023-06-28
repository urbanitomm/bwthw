
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//String conversion format
const String stringFormat = 'yyyy-MM-dd';

String getTodayDate(){
    //Format today's date
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(stringFormat).format(now);
    return formattedDate;
  }

DateTime stringToDate(String stringDate){
  //Conversion from String to DateTime
  final parsedDate = DateTime.parse(stringDate);
  return parsedDate;
}

String dateToString(DateTime date){
  //Conversion from DateTime to String
  final stringDate = DateFormat(stringFormat).format(date);
  return stringDate;
}


call(String celln)async{
 final cellurl = Uri.parse("tel://$celln");
  if (await canLaunchUrl(cellurl)) {
    launchUrl(cellurl);
  } else {
    throw 'Could not launch $cellurl';
  }
}