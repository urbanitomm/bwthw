
import 'package:intl/intl.dart';

//Formato di conversione delle mie stringhe
const String stringFormat = 'yyyy-MM-dd';

String getTodayDate(){
    //Prendo la data di oggi e la formatto correttamente
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(stringFormat).format(now);
    return formattedDate;
  }

DateTime stringToDate(String stringDate){
  final parsedDate = DateTime.parse(stringDate);
  return parsedDate;
}

String dateToString(DateTime date){
  final stringDate = DateFormat(stringFormat).format(date);
  return stringDate;
}