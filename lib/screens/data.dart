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
import 'package:progetto_wearable/utils/funcs.dart';

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

  //...era qui//
  List<HeartRate> heartRates = [];
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
      print('heartRates: $heartRates');
    } catch (e) {
      // Handle error loading data
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
      ],
    ));
  }
}

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

  insertHeartRates(resultHr, context, date);
  print('finished with DB');
  return resultHr;
}

void insertHeartRates(
    List<HeartRate> heartRates, BuildContext context, String dateFormatted) {
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
  _requestDataSleep(context, dateFormatted);
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

  insertSleep(resultSleep, context, dateFormatted);

  return resultSleep;
}

void insertSleep(
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
    sleeps?.efficiency,
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
