import 'dart:convert';
import 'dart:io';
import 'dart:async';
//import 'dart:js';
//import 'dart:js_util';
//import 'dart:js' as js;

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progetto_wearable/database/entities/HRentity.dart';
import 'package:progetto_wearable/models/hr.dart';
//import 'package:progetto_wearable/models/restingHr.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progetto_wearable/models/sleep.dart';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:progetto_wearable/repository/providerHR.dart';
import 'package:progetto_wearable/repository/providerSleep.dart';
import 'package:progetto_wearable/database/entities/sleepentry.dart';

class Data extends StatefulWidget {
  static const route = '/data/';
  static const routeDisplayName = 'DataPage';

  const Data({Key? key}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final _dateController = TextEditingController();
  String string_result_alcol_check = '';
  //...era qui//
  List<HeartRate> heartRates = [];
  List<Map<String, double?>> effWeek = [];

  bool _isLoading = false;

  Future<void> _loadData() async {
    //final selectedDate = _dateController.text;
    //heartRates = await _dataSourceFuture;
    //heartRates = await _requestDataHR(context, selectedDate);

    setState(() {
      _isLoading = true;
    });

    try {
      var selectedDate;
      if (_dateController.text.isEmpty) {
        selectedDate = (DateTime.now().subtract(Duration(days: 1))).toString();

        List<String> date = selectedDate.split(' ');
        selectedDate = date[0];
      } else {
        selectedDate = _dateController.text;
      }
      print('selected date: $selectedDate');

      heartRates = await _requestDataHR(context, selectedDate);
      effWeek = await efficiencyWeek(context, selectedDate);
      print('effWeek: $effWeek');
      bool? result_alcol_check = await AlcolCheck(selectedDate, context);
      if (result_alcol_check == null) {
        setState(() {
          string_result_alcol_check = 'No data available';
        });
      } else if (result_alcol_check == true) {
        setState(() {
          string_result_alcol_check =
              'We suppose you have consumed alcohol yesterday';
        });
      } else {
        setState(() {
          string_result_alcol_check =
              'We suppose you have not consumed alcohol yesterday';
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    //_dataSourceFuture = _requestDataHR(context, _dateController.text);
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    /// inserire in riga 76 per il DB
    return SingleChildScrollView(
        child: Column(
      children: [
        // DATE SELECTION
        TextField(
          controller: _dateController,
          readOnly: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Select a date:',
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(Duration(days: 1)),
                  firstDate: DateTime(2021),
                  lastDate: DateTime.now().subtract(Duration(days: 1)),
                );
                if (selectedDate != null) {
                  _dateController.text = dateToString(selectedDate);
                  _loadData();
                }
              },
            ),
          ),
        ),
        if (_isLoading) CircularProgressIndicator(),
        // SPACING
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              _dateController.text.isEmpty
                  ? 'Heart rate of yesterday'
                  : 'Heart rate of ${_dateController.text}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ), // Set the height of the SizedBox widget to a smaller value
        ),
        // ALCOHOL Graph
        SizedBox(
          height: 550,
          child: LineChart(
            LineChartData(
                minX: 0,
                minY: 0,
                maxY: 200,
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.blue,
                      strokeWidth: 0.5,
                    );
                  },
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Colors.blue,
                      strokeWidth: 0.5,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: heartRates
                        .map((e) => FlSpot(
                            timeStringToDouble(e.time), e.value.toDouble()))
                        .toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                        show: true, color: Colors.blue.withOpacity(0.3)),
                  )
                ],
                titlesData: FlTitlesData(
                  bottomTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                )),
          ),
        ),
        // SPACING
        SizedBox(
          height:
              50, // Set the height of the SizedBox widget to a smaller value
          // add a text in the vertical center

          child: Center(
            child: Text(
              'Sleep effinciency in the last week',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                  maxY: 100,
                  borderData: FlBorderData(
                      border: const Border(
                    top: BorderSide.none,
                    right: BorderSide(color: Colors.blue, width: 1),
                    left: BorderSide(color: Colors.blue, width: 1),
                    bottom: BorderSide(color: Colors.blue, width: 1),
                  )),
                  groupsSpace: 10,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: effWeek[0]['efficiency'] ?? 0,
                        color: Colors.blue,
                        width: 20,
                      ),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                        toY: effWeek[1]['efficiency'] ?? 0,
                        color: Colors.blue,
                        width: 20,
                      ),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                        toY: effWeek[2]['efficiency'] ?? 0,
                        color: Colors.blue,
                        width: 20,
                      ),
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(
                        toY: effWeek[3]['efficiency'] ?? 0,
                        color: Colors.blue,
                        width: 20,
                      ),
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(
                        toY: effWeek[4]['efficiency'] ?? 0,
                        color: Colors.blue,
                        width: 20,
                      ),
                    ]),
                    BarChartGroupData(x: 5, barRods: [
                      BarChartRodData(
                        toY: effWeek[5]['efficiency'] ?? 0,
                        color: Colors.blue,
                        width: 20,
                      ),
                    ]),
                    BarChartGroupData(x: 6, barRods: [
                      BarChartRodData(
                        toY: effWeek[6]['efficiency'] ?? 0,
                        color: Colors.blue,
                        width: 20,
                      ),
                    ]),
                  ]),
            )),

        Container(
          padding: const EdgeInsets.all(10),
          color: Color.fromARGB(255, 129, 7, 143),
          child: Text(
            string_result_alcol_check,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        )
      ],
    ));
  }
} //string_result_alcol_check

// This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
Future<int?> _authorize() async {
  //Create request
  //print('asked aurorization');
  final url = Impact.baseUrl + Impact.tokenEndpoint;
  final body = {
    'username': Impact.username,
    'password': Impact.password,
  };

  //Send request
  final response = await http.post(
    Uri.parse(url),
    body: body,
  );

  //Check response
  if (response.statusCode == 200) {
    //Decode response
    final Map<String, dynamic> data = jsonDecode(response.body);
    final String accessToken = data['access'];
    final String refreshToken = data['refresh'];

    //Store tokens
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access', accessToken);
    prefs.setString('refresh', refreshToken);

    print('authorized');
    return 200;
  } else {
    return null;
  }
}

// This method allows to refresh the JWT token pair from IMPACT and store it in SharedPreferences
Future<int> _refreshToken() async {
  //Create request
  final url = Impact.baseUrl + Impact.refreshEndpoint;
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh');
  final body = {'refresh': refreshToken};

  //Send request
  final response = await http.post(
    Uri.parse(url),
    body: body,
  );

  //Check response
  if (response.statusCode == 200) {
    //Decode response
    final Map<String, dynamic> data = jsonDecode(response.body);
    final String accessToken = data['access'];

    //Store tokens
    prefs.setString('access', accessToken);

    return 200;
  } else {
    return response.statusCode;
  }
}

// This method allows to obtain the HR data from IMPACT
Future<List<HeartRate>> _requestDataHR(
    BuildContext context, String date) async {
  final result = await _authorize();
  result == 200 ? 'You have been authorized' : 'You have been denied access';
  //initialize the result
  List<HeartRate> resultHr = [];
  //Get the access token from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString('access');

  //If the token is expired, refresh it
  if (JwtDecoder.isExpired(accessToken!)) {
    await _refreshToken();
    accessToken = prefs.getString('access');
  }

  //Create request
  //DateTime date = DateTime.now().subtract(const Duration(days: 1));
  //String dateFormatted = dateToString(date);

  //final url = Impact.baseUrl + hrEndpoint;
  //print(Impact.hrEndpoint);
  final url = Impact.baseUrl +
      '/data/v1/heart_rate/patients/Jpefaq6m58/day/' +
      date +
      '/'; //+ dateFormatted;
  print('url: $url');
  final headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

  //Send request
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  print(response.statusCode);

  //Check response

  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);

    for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
      resultHr.add(HeartRate.fromJson(decodedResponse['data']['data'][i]));
    }
  } else {
    print(response.statusCode);
  }

  await insertHeartRates(resultHr, context, date);

  print('finished with DB');
  return resultHr;
}

Future<void> insertHeartRates(List<HeartRate> heartRates, BuildContext context,
    String dateFormatted) async {
  List<HREntity> hrEntities = [];
  print('dateFormatted');
  print(dateFormatted); //dateFormatted is in the format yyyy-MM-dd

  // Questo è il for per inserire tutte le entry di una data
  for (var heartRate in heartRates) {
    List cmp0 =
        dateFormatted.split('-'); //dateFormatted is in the format yyyy-MM-dd
    int year = int.parse(cmp0[0]);
    int month = int.parse(cmp0[1]);
    int day = int.parse(cmp0[2]);
    List cmp1 =
        heartRate.time.split(':'); //heartRate.time is in the format hh:mm:ss
    int hour = int.parse(cmp1[0]);
    int minute = int.parse(cmp1[1]);
    int second = int.parse(cmp1[2]);
    DateTime ddt = DateTime(year, month, day, hour, minute, second);
    double time = dateTimeToDouble2(ddt);
    var hrEntity = HREntity(
      null,
      dateFormatted,
      time,
      heartRate.value,
    );

    hrEntities.add(hrEntity);
  }
  Provider.of<ProviderHR>(context, listen: false).insertMultipleHR(hrEntities);
  print('inserted HR in the DB');
  //call the function _requestDataSleep
  await _requestDataSleep(context, dateFormatted);
}

// This method allows to obtain the Sleep data from IMPACT
Future<Sleep?> _requestDataSleep(
    BuildContext context, String dateFormatted) async {
  final result = await _authorize();
  result == 200 ? 'You have been authorized' : 'You have been denied access';
  //initialize the result
  Sleep? resultSleep = null;

  //Get the access token from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString('access');

  //If the token is expired, refresh it
  if (JwtDecoder.isExpired(accessToken!)) {
    await _refreshToken();
    accessToken = prefs.getString('access');
  }

  //Create request

  //final url = Impact.baseUrl + hrEndpoint;
  //print(Impact.sleepEndpoint);
  final url = Impact.baseUrl +
      '/data/v1/sleep/patients/Jpefaq6m58/day/' +
      dateFormatted +
      '/'; //+ dateFormatted;
  print('url: $url');

  final headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

  //Send request
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  print(response.statusCode);

  //Check response

  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);

    for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
      resultSleep = (Sleep.fromJson(decodedResponse['data']['data'][i]));
      print('sleep');
      print(resultSleep);
    }
  } else {
    print('error' + response.statusCode.toString());
  }

  await insertSleep(resultSleep, context, dateFormatted);
  var prev_date = DateTime.parse(dateFormatted);
  prev_date = prev_date.subtract(Duration(days: 1));
  var prev_date_formatted = dateToString(prev_date);
  await insertSleep(resultSleep, context, prev_date_formatted);

  return resultSleep;
}

Future<void> insertSleep(
    Sleep? sleeps, BuildContext context, String dateFormatted) async {
  var sl;
  print('start time and endtime as they are provided');
  print(sleeps?.startTime); //eg. 07-04 23:29:00
  print(sleeps?.endTime);
  print('start time and endtime converted in DateTime format');
  print(stringToDateTime(sleeps?.startTime));
  print(stringToDateTime(sleeps?.endTime));
  sl = Sleepentry(
    dateFormatted,
    dateTimeToDouble2(stringToDateTime(sleeps
        ?.startTime)), //sleeps?.startTime is in the format MM-gg (hh:mm:ss)
    dateTimeToDouble2(stringToDateTime(
        sleeps?.endTime)), //sleeps?.endTime is in the format MM-gg (hh:mm:ss)
    sleeps?.duration,
    sleeps?.efficiency.toDouble(),
  );
  print('Date of sleep, startTime and endTime as they are provided');
  print(
    sleeps?.dateOfSleep,
  );
  print(sleeps?.startTime);
  print(sleeps?.endTime);
  print('sleep Entry is');
  print(sl.date);
  print(sl.startTime);
  print(sl.endTime);
  print(sl.duration);
  print(sl.efficiency);
  print('inverse conversion of startTime and endTime from double to dateTime');
  print(doubleToDateTime2(sl.startTime));
  print(doubleToDateTime2(sl.endTime));
  Provider.of<ProviderSleep>(context, listen: false).insertSleep(sl);
  Sleepentry? sl1 = await Provider.of<ProviderSleep>(context, listen: false)
      .findDateSleep(sl.date);
  print('sleep Entry extracted is');
  print(sl1?.date);
  print(sl1?.startTime);
  print(sl1?.endTime);
  print(sl1?.duration);
  print(sl1?.efficiency);
  print('inserted sleep in the DB');
}

Future<bool?> AlcolCheck(String date, BuildContext context) async {
  DateTime dateTime = DateTime.parse(date);
  //previous day
  DateTime previousDay = dateTime.subtract(Duration(days: 1));
  String previousDate = previousDay.toString().substring(0, 10);

  Sleepentry? sleepentry_current_day =
      await Provider.of<ProviderSleep>(context, listen: false)
          .findDateSleep(previousDate);
  bool efficiency_param;
  bool sleep_time_param;
  bool HR_param;
  if (sleepentry_current_day == null ||
      sleepentry_current_day.startTime == null ||
      sleepentry_current_day.endTime == null ||
      sleepentry_current_day.duration == null ||
      sleepentry_current_day.efficiency == null) {
    return null;
  } else {
    DateTime midnight =
        DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
    if (doubleToDateTime2(sleepentry_current_day.startTime!)
        .isAfter(midnight)) {
      List<int?> valuesHR =
          await Provider.of<ProviderHR>(context, listen: false)
              .findEntriesBetween(date, sleepentry_current_day.startTime!,
                  sleepentry_current_day.endTime!);
      double meanHR = meanValue(valuesHR);
      double placebo_HR = (meanHR - 56.4).abs();
      double Alcohol_HR = (meanHR - 65).abs();

      if (placebo_HR < Alcohol_HR) {
        HR_param =
            false; //the nocturnal HR is closer to the mean HR of the placebo group
      } else {
        HR_param =
            true; //the nocturnal HR is closer to the mean HR of the alcohol group
      }

      double placebo_duration =
          (sleepentry_current_day.duration! - 436.6).abs();
      double Alcohol_duration =
          (sleepentry_current_day.duration! - 421.3).abs();
      if (placebo_duration < Alcohol_duration) {
        sleep_time_param = false;
      } else {
        sleep_time_param = true;
      }

      double placebo_efficiency =
          (sleepentry_current_day.efficiency! - 91.2).abs();
      double Alcohol_efficiency =
          (sleepentry_current_day.efficiency! - 88.0).abs();
      if (placebo_efficiency < Alcohol_efficiency) {
        efficiency_param = false;
      } else {
        efficiency_param = true;
      }
    } else {
      List<int?> valuesHR_after_startTime =
          await Provider.of<ProviderHR>(context, listen: false)
              .findEntriesAfter(date, sleepentry_current_day.startTime!);
      List<int?> valuesHR_before_endTime =
          await Provider.of<ProviderHR>(context, listen: false)
              .findEntriesBefore(previousDate, sleepentry_current_day.endTime!);
      List<int?> valuesHR = [];
      valuesHR.addAll(valuesHR_after_startTime);
      valuesHR.addAll(valuesHR_before_endTime);
      double meanHR = meanValue(valuesHR);
      double placebo_HR = (meanHR - 56.4).abs();
      double Alcohol_HR = (meanHR - 65).abs();

      if (placebo_HR < Alcohol_HR) {
        HR_param =
            false; //the nocturnal HR is closer to the mean HR of the placebo group
      } else {
        HR_param =
            true; //the nocturnal HR is closer to the mean HR of the alcohol group
      }

      double placebo_duration =
          (sleepentry_current_day.duration! - 436.6).abs();
      double Alcohol_duration =
          (sleepentry_current_day.duration! - 421.3).abs();
      if (placebo_duration < Alcohol_duration) {
        sleep_time_param = false;
      } else {
        sleep_time_param = true;
      }

      double placebo_efficiency =
          (sleepentry_current_day.efficiency! - 91.2).abs();
      double Alcohol_efficiency =
          (sleepentry_current_day.efficiency! - 88.0).abs();
      if (placebo_efficiency < Alcohol_efficiency) {
        efficiency_param = false;
      } else {
        efficiency_param = true;
      }
    }
    return (HR_param && sleep_time_param) ||
        (HR_param && efficiency_param) ||
        (efficiency_param && sleep_time_param);
  }
}

double meanValue(List<int?> valuesHR) {
  int sum = 0;
  for (int i = 0; i < valuesHR.length; i++) {
    sum += valuesHR[i]!;
  }
  return sum / valuesHR.length;
}

/* PROVA CON UNA SOLA QUERY

Future<List<Map<String, double?>>> efficiencyWeek(
    BuildContext context, String selectedDate) async {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateTime selectedDateTime = formatter.parse(selectedDate);
  final List<Map<String, double?>> efficiencyWeek = [];
  List<String> dates = [];
  print('EFF WEEK selected date is $selectedDate');
  for (int i = 0; i < 7; i++) {
    DateTime date = selectedDateTime.subtract(Duration(days: i));
    dates.add(formatter.format(date));
  }
  print('EFF WEEK dates are $dates');

  final List<double?>? efficiency = await Provider.of<ProviderSleep>(context,
          listen: false)
      .findWeekEfficiency(
          dates[0], dates[1], dates[2], dates[3], dates[4], dates[5], dates[6]);

  for (int i = 0; i < efficiency!.length; i++) {
    Map<String, double?> data = {
      'date': i.toDouble(),
      'efficiency': efficiency[i],
    };
    efficiencyWeek.add(data);
  }

  return efficiencyWeek;
}*/

// PROVA CON 7 QUERY

Future<List<Map<String, double?>>> efficiencyWeek(
    BuildContext context, String selectedDate) async {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateTime selectedDateTime = formatter.parse(selectedDate);
  final List<Map<String, double?>> efficiencyWeek = [];
  List<String> dates = [];
  for (int i = 0; i < 7; i++) {
    DateTime date = selectedDateTime.subtract(Duration(days: i));
    dates.add(formatter.format(date));
  }
  for (int i = 0; i < dates.length; i++) {
    final double? efficiency =
        await Provider.of<ProviderSleep>(context, listen: false)
            .findEfficiency(dates[i]);
    efficiencyWeek.add({'date': i.toDouble(), 'efficiency': efficiency});
    print('Date: ${dates[i]}');
    print('efficiency: ${efficiencyWeek[i].toString()}');
  }
  return efficiencyWeek;
}
