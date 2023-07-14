import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progetto_wearable/database/entities/HRentity.dart';
import 'package:progetto_wearable/models/hr.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progetto_wearable/models/sleep.dart';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _dateController = TextEditingController();
  String string_result_alcol_check = '';
  //...era qui//
  List<HeartRate> heartRates = [];
  List<HeartRate> heartRates_prev_day = [];
  List<Map<String, double?>> effWeek = [];
  List<Map<String, double?>> durWeek = [];

  bool _isLoading = false;

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    var selectedDate;
    try {
      if (_dateController.text.isEmpty) {
        selectedDate = (DateTime.now().subtract(Duration(days: 1))).toString();

        List<String> date = [];
        date = selectedDate.split(' ');
        selectedDate = date[0];
      } else {
        selectedDate = _dateController.text;
      }
      print('selected date: $selectedDate');

      heartRates = await _requestDataHR(context, selectedDate);

      var prev_date = DateTime.parse(selectedDate);
      prev_date = prev_date.subtract(Duration(days: 1));
      var prev_date_formatted = dateToString(prev_date).substring(0, 10);
      print('prev_date_formatted: $prev_date_formatted');
      heartRates_prev_day = await _requestDataHR(context, prev_date_formatted);
      //I retrieve data from both current day and previous day since sometimes it's necessary to have HR data from the startaime to midnight
      await insertHeartRates(heartRates, context, selectedDate);
      await insertHeartRates(heartRates_prev_day, context, prev_date_formatted);

      Sleep? requ_sleep = await _requestDataSleep(context, selectedDate);
      await insertSleep(requ_sleep, context, selectedDate);

      double? st = await Provider.of<ProviderSleep>(context, listen: false)
          .findStartTime(selectedDate);
      if (st == null) {
        st = 0;
      }

      effWeek = await efficiencyWeek(context, selectedDate);

      durWeek = await durationWeek(context, selectedDate);

      bool? result_alcol_check = await AlcolCheck(selectedDate, context);
      if (result_alcol_check == null) {
        setState(() {
          string_result_alcol_check = 'No data available';
        });
      } else if (result_alcol_check == true) {
        setState(() {
          string_result_alcol_check =
              'We suppose you have consumed alcohol on the  $prev_date_formatted';
        });
      } else {
        setState(() {
          string_result_alcol_check =
              'We suppose you have not consumed alcohol on the  $prev_date_formatted';
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
    /*int maxHR = 0;
    if (heartRates != null) {
      maxHR = heartRates.map((hr) => hr.value).reduce((a, b) => a > b ? a : b);
      maxHR = ((maxHR / 10).ceil() * 10).toInt();
    }
*/

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
                  await _loadData();
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
          ),
        ),
        // ALCOHOL Graph
        Center(
          child: SizedBox(
            height: 550,
            child: LineChart(
              LineChartData(
                minX: 0,
                minY: 0,
                maxY: (heartRates.fold(
                                0,
                                (max, element) =>
                                    element.value > max ? element.value : max) /
                            10)
                        .ceil() *
                    10.0, // slower but dynamic
                //200, faster but not dynamic!
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final hours = ((value) / 3600).floor();
                      if (hours == 0) return Text('');
                      if (hours < 23) {
                        return Text(
                          '$hours:00',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        );
                      } else
                        return Text('');
                    },
                  )),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${value.toInt()} ',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'BPM',
                                    ),
                                  ],
                                ),
                              ))),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${value.toInt()} ',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'BPM',
                                    ),
                                  ],
                                ),
                              ))),
                ),
                gridData: FlGridData(
                  show: false,
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
              ),
            ),
          ),
        ),
        // SPACING
        SizedBox(
          height: 70,
          child: Center(
            child: Text(
              _dateController.text.isEmpty
                  ? 'Sleep efficiency in the last week'
                  : 'Sleep efficiency in the week from ${_dateController.text} to ${dateToString(DateTime.parse(_dateController.text).subtract(Duration(days: 6)))}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (_isLoading) CircularProgressIndicator(),
        Center(
          child: SizedBox(
              height: 300,
              child: effWeek.isNotEmpty
                  ? BarChart(
                      BarChartData(
                          gridData: FlGridData(show: false),
                          maxY: 100,
                          borderData: FlBorderData(
                              border: const Border(
                            top: BorderSide.none,
                            right: BorderSide(color: Colors.blue, width: 1),
                            left: BorderSide(color: Colors.blue, width: 1),
                            bottom: BorderSide(color: Colors.blue, width: 1),
                          )),
                          groupsSpace: 10,
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                '${value.toInt()}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            )),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                '${value.toInt()}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            )),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value == 0)
                                  return Column(
                                    children: [
                                      Text('Selected',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8)),
                                      Text('day',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8)),
                                    ],
                                  );
                                if (value == 1)
                                  return Column(
                                    children: [
                                      Text('${value.toInt()}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8)),
                                      Text('day before',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8)),
                                    ],
                                  );
                                return Column(
                                  children: [
                                    Text('${value.toInt()}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 8)),
                                    Text('days before',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 8)),
                                  ],
                                );
                              },
                            )),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(
                                toY: effWeek[0]['efficiency'] ?? 0,
                                color: durWeek[0]['efficiency'] != null &&
                                        durWeek[0]['efficiency']! <= 90
                                    ? Colors.red
                                    : durWeek[0]['efficiency'] != null &&
                                            durWeek[0]['efficiency']! >= 95
                                        ? Colors.green
                                        : Colors.yellow,
                                width: 20,
                              ),
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(
                                toY: effWeek[1]['efficiency'] ?? 0,
                                color: durWeek[1]['efficiency'] != null &&
                                        durWeek[1]['efficiency']! <= 95
                                    ? Colors.red
                                    : durWeek[1]['efficiency'] != null &&
                                            durWeek[1]['efficiency']! >= 98
                                        ? Colors.green
                                        : Colors.yellow,
                                width: 20,
                              ),
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(
                                toY: effWeek[2]['efficiency'] ?? 0,
                                color: durWeek[2]['efficiency'] != null &&
                                        durWeek[2]['efficiency']! <= 95
                                    ? Colors.red
                                    : durWeek[2]['efficiency'] != null &&
                                            durWeek[2]['efficiency']! >= 98
                                        ? Colors.green
                                        : Colors.yellow,
                                width: 20,
                              ),
                            ]),
                            BarChartGroupData(x: 3, barRods: [
                              BarChartRodData(
                                toY: effWeek[3]['efficiency'] ?? 0,
                                color: durWeek[3]['efficiency'] != null &&
                                        durWeek[3]['efficiency']! <= 95
                                    ? Colors.red
                                    : durWeek[3]['efficiency'] != null &&
                                            durWeek[3]['efficiency']! >= 98
                                        ? Colors.green
                                        : Colors.yellow,
                                width: 20,
                              ),
                            ]),
                            BarChartGroupData(x: 4, barRods: [
                              BarChartRodData(
                                toY: effWeek[4]['efficiency'] ?? 0,
                                color: durWeek[4]['efficiency'] != null &&
                                        durWeek[4]['efficiency']! <= 95
                                    ? Colors.red
                                    : durWeek[4]['efficiency'] != null &&
                                            durWeek[4]['efficiency']! >= 98
                                        ? Colors.green
                                        : Colors.yellow,
                                width: 20,
                              ),
                            ]),
                            BarChartGroupData(x: 5, barRods: [
                              BarChartRodData(
                                toY: effWeek[5]['efficiency'] ?? 0,
                                color: durWeek[5]['efficiency'] != null &&
                                        durWeek[5]['efficiency']! <= 95
                                    ? Colors.red
                                    : durWeek[5]['efficiency'] != null &&
                                            durWeek[5]['efficiency']! >= 98
                                        ? Colors.green
                                        : Colors.yellow,
                                width: 20,
                              ),
                            ]),
                            BarChartGroupData(x: 6, barRods: [
                              BarChartRodData(
                                toY: effWeek[6]['efficiency'] ?? 0,
                                color: durWeek[6]['efficiency'] != null &&
                                        durWeek[6]['efficiency']! <= 95
                                    ? Colors.red
                                    : durWeek[6]['efficiency'] != null &&
                                            durWeek[6]['efficiency']! >= 98
                                        ? Colors.green
                                        : Colors.yellow,
                                width: 20,
                              ),
                            ]),
                          ]),
                    )
                  : Center(child: Text('No data'))),
        ),
        // SPACING
        SizedBox(
          height: 70,
          child: Center(
            child: Text(
              _dateController.text.isEmpty
                  ? 'Sleep duration in the last week'
                  : 'Sleep duration in the week from ${_dateController.text} to ${dateToString(DateTime.parse(_dateController.text).subtract(Duration(days: 6)))}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (_isLoading) CircularProgressIndicator(),
        Center(
          child: SizedBox(
            height: 300,
            child: durWeek.isNotEmpty
                ? BarChart(
                    BarChartData(
                        gridData: FlGridData(show: false),
                        //swapAnimationDuration: Duration(milliseconds: 150),
                        maxY:
                            10, //(durWeek.fold(0, (max, element) => element['duration'] != null && element['duration']! > max ? element['duration']! : max) / 2).ceil() * 2.0,
                        borderData: FlBorderData(
                            border: const Border(
                          top: BorderSide.none,
                          right: BorderSide(color: Colors.blue, width: 1),
                          left: BorderSide(color: Colors.blue, width: 1),
                          bottom: BorderSide(color: Colors.blue, width: 1),
                        )),
                        groupsSpace: 10,
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()} h',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          )),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()} h',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          )),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value == 0)
                                return Column(
                                  children: [
                                    Text('Selected',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 8)),
                                    Text('day',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 8)),
                                  ],
                                );
                              if (value == 1)
                                return Column(
                                  children: [
                                    Text('${value.toInt()}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 8)),
                                    Text('day before',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 8)),
                                  ],
                                );
                              return Column(
                                children: [
                                  Text('${value.toInt()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8)),
                                  Text('days before',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8)),
                                ],
                              );
                            },
                          )),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(
                              toY: durWeek[0]['duration'] ?? 0,
                              color: durWeek[0]['duration'] != null &&
                                      durWeek[0]['duration']! < 6
                                  ? Colors.red
                                  : durWeek[0]['duration'] != null &&
                                          durWeek[0]['duration']! > 8
                                      ? Colors.green
                                      : Colors.yellow,
                              width: 20,
                            ),
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(
                              toY: durWeek[1]['duration'] ?? 0,
                              color: durWeek[1]['duration'] != null &&
                                      durWeek[1]['duration']! < 6
                                  ? Colors.red
                                  : durWeek[1]['duration'] != null &&
                                          durWeek[1]['duration']! > 8
                                      ? Colors.green
                                      : Colors.yellow,
                              width: 20,
                            ),
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(
                              toY: durWeek[2]['duration'] ?? 0,
                              color: durWeek[2]['duration'] != null &&
                                      durWeek[2]['duration']! < 6
                                  ? Colors.red
                                  : durWeek[2]['duration'] != null &&
                                          durWeek[2]['duration']! > 8
                                      ? Colors.green
                                      : Colors.yellow,
                              width: 20,
                            ),
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(
                              toY: durWeek[3]['duration'] ?? 0,
                              color: durWeek[3]['duration'] != null &&
                                      durWeek[3]['duration']! < 6
                                  ? Colors.red
                                  : durWeek[3]['duration'] != null &&
                                          durWeek[3]['duration']! > 8
                                      ? Colors.green
                                      : Colors.yellow,
                              width: 20,
                            ),
                          ]),
                          BarChartGroupData(x: 4, barRods: [
                            BarChartRodData(
                              toY: durWeek[4]['duration'] ?? 0,
                              color: durWeek[4]['duration'] != null &&
                                      durWeek[4]['duration']! < 6
                                  ? Colors.red
                                  : durWeek[4]['duration'] != null &&
                                          durWeek[4]['duration']! > 8
                                      ? Colors.green
                                      : Colors.yellow,
                              width: 20,
                            ),
                          ]),
                          BarChartGroupData(x: 5, barRods: [
                            BarChartRodData(
                              toY: durWeek[5]['duration'] ?? 0,
                              color: durWeek[5]['duration'] != null &&
                                      durWeek[5]['duration']! < 6
                                  ? Colors.red
                                  : durWeek[5]['duration'] != null &&
                                          durWeek[5]['duration']! > 8
                                      ? Colors.green
                                      : Colors.yellow,
                              width: 20,
                            ),
                          ]),
                          BarChartGroupData(x: 6, barRods: [
                            BarChartRodData(
                              toY: durWeek[6]['duration'] ?? 0,
                              color: durWeek[6]['duration'] != null &&
                                      durWeek[6]['duration']! < 6
                                  ? Colors.red
                                  : durWeek[6]['duration'] != null &&
                                          durWeek[6]['duration']! > 8
                                      ? Colors.green
                                      : Colors.yellow,
                              width: 20,
                            ),
                          ]),
                        ]),
                  )
                : Text('No data available'),
          ),
        ),
        SizedBox(
          height: 50,
          child: Center(),
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
        ),
      ],
    ));
  }
} //string_result_alcol_check

// This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
Future<int?> _authorize() async {
  //Create request
  print('asking aurorization');
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
  print('before authorize');
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
    print('-------REQUESTING HR ----------');
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
  print(
      '---------------------------DATA FROM INSERT HEART RATES---------------------------');
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
    //print('------------HR ENTITY FROM INSERT HEART RATES-----------------');
    //print(hrEntity);
    //print('------------END HR ENTITY FROM INSERT HEART RATES-----------------');
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
          .findDateSleep(date);
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

// Retreive the sleep efficiency of the last 7 days

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

// Retreive the sleep duration of the last 7 days

Future<List<Map<String, double?>>> durationWeek(
    BuildContext context, String selectedDate) async {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateTime selectedDateTime = formatter.parse(selectedDate);
  final List<Map<String, double?>> durationWeek = [];
  List<String> dates = [];
  for (int i = 0; i < 7; i++) {
    DateTime date = selectedDateTime.subtract(Duration(days: i));
    dates.add(formatter.format(date));
  }
  for (int i = 0; i < dates.length; i++) {
    final double? duration =
        await Provider.of<ProviderSleep>(context, listen: false)
            .findDuration(dates[i]);
    durationWeek.add({
      'date': i.toDouble(),
      'duration': duration != null ? duration / (1000 * 60 * 60) : null,
    });
    print('Date: ${dates[i]}');
    print('duration: ${durationWeek[i].toString()}');
  }
  return durationWeek;
}
