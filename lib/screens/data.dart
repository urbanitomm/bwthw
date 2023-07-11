import 'dart:convert';
import 'dart:io';
import 'dart:async';
//import 'dart:js_util';
//import 'dart:js' as js;

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  List<HeartRate> heartRates_prev_day = [];
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
      var prev_date = DateTime.parse(selectedDate);
      prev_date = prev_date.subtract(Duration(days: 1));
      var prev_date_formatted = dateToString(prev_date);
      heartRates_prev_day = await _requestDataHR(context, prev_date_formatted);
      //I retrieve data from both current day and previous day since sometimes it's necessary to have HR data from the startaime to midnight
      await insertHeartRates(heartRates, context, selectedDate);
      await insertHeartRates(heartRates_prev_day, context, prev_date_formatted);

      Sleep? requ_sleep = await _requestDataSleep(context, selectedDate);
      await insertSleep(requ_sleep, context, selectedDate);

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
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    /// inserire in riga 76 per il DB
    return SingleChildScrollView(
        child: Column(
      children: [
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
        SizedBox(
          height:
              10, // Set the height of the SizedBox widget to a smaller value
        ),
        SizedBox(
          height: 550,
          child: LineChart(
            LineChartData(
                minX: 0,
                minY: 0,
                maxY: 160,
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
    print('------------HR ENTITY FROM INSERT HEART RATES-----------------');
    print(hrEntity);
    print('------------END HR ENTITY FROM INSERT HEART RATES-----------------');
    hrEntities.add(hrEntity);
  }
  Provider.of<ProviderHR>(context, listen: false).insertMultipleHR(hrEntities);
  print('inserted HR in the DB');
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

  print(response.statusCode); //statusCode is int type

  print((response.body));
  if (response.statusCode == 200) {
    // Parse the JSON response

    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    Map<String, dynamic> data = decodedResponse['data'];

    if (data.isEmpty) {
      print('data is empty');

      resultSleep = null;
    } else {
      Map<String, dynamic> sleepData = data['data'][0];
//result of the extratcted data from the server
      print(
          '---------------------------------------------DATA FROM REQUEST_DATA_SLEEP---------------------------------------------------');
      print(sleepData['dateOfSleep']); //dateOfSleep is in the format MM-dd
      print(sleepData['startTime']); //startTime is in the format MM-dd hh:mm:ss
      print(sleepData['endTime']); //endTime is in the format MM-dd hh:mm:ss
      print(sleepData['duration']); //duration is in ms
      print(sleepData['efficiency']); //efficiency is in %
      print(
          '---------------------------------------------END DATA FROM REQUEST_DATA_SLEEP---------------------------------------------------');
      String dateOfSleep = sleepData['dateOfSleep'].toString();
      String startTime = sleepData['startTime'].toString();
      String endTime = sleepData['endTime'].toString();
      double duration = (sleepData['duration'] as num?)?.toDouble() ?? 0.0;
      double efficiency = (sleepData['efficiency'] as num?)?.toDouble() ?? 0.0;

      resultSleep = Sleep.fromJson({
        'dateOfSleep': dateOfSleep,
        'startTime': startTime,
        'endTime': endTime,
        'duration': duration,
        'efficiency': efficiency,
      });
    }
    return resultSleep;
  } else {
    //if the response is not 200
    print(response.statusCode);
    return null;
  }
}

Future<void> insertSleep(
    Sleep? sleeps, BuildContext context, String dateFormatted) async {
  var sl;
  print(
      '---------------------------DATA FROM INSERT SLEEP---------------------------');
  print('input data from the Sleep? data type');
  print('Date of sleep, start time and endtime as they are provided');
  print(
    sleeps?.dateOfSleep,
  ); //eg. 07-14
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
    sleeps?.efficiency,
  );

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
  print(
      '------------------------------------------end of insertSleep function----------------------------------------------------------------');
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
