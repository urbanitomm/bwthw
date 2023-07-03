import 'dart:convert';
import 'dart:io';
import 'dart:async';
//import 'dart:js' as js;

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progetto_wearable/database/entities/HRentity.dart';
import 'package:progetto_wearable/models/hr.dart';
//import 'package:progetto_wearable/models/restingHr.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:progetto_wearable/repository/providerHR.dart';

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

  //////////////////////////////////////////////////////////////////////// DA QUI
  final Future<List<HeartRate>> _dataSourceFuture = _requestDataHR();

  List<HeartRate> heartRates = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    heartRates = await _dataSourceFuture;
    setState(() {});
    print('provaaaaa');
    //print the size of the list
    print(heartRates.length);
    //pritn the type of time
    print('type');
    print(heartRates[1000].time.runtimeType);
    print('time string');
    print(heartRates[1000].time);
    print('time double');
    print(timeStringToDouble(heartRates[1000].time));
  }

  ////////////////////////////////////////////////////////// FINO A QUI
  /// inserire in riga 76 per il DB

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        minX: 0,
        minY: 0,
        maxY: 150,
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.black,
              strokeWidth: 0.5,
            );
          },
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Colors.black,
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
                .map((e) =>
                    FlSpot(timeStringToDouble(e.time), e.value.toDouble()))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData:
                BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
          )
        ]));
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
// This method allows to obtain the data from IMPACT

Future<List<HeartRate>> _requestDataHR() async {
  // PER DB:  Future<List<HeartRate>> _requestDataHR(BuildContext context) async {
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
  final url = Impact.baseUrl + Impact.hrEndpoint;
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

  //insertHeartRates(heartRates, context)
  return resultHr;
}

void insertHeartRates(List<HeartRate> heartRates, BuildContext context) {
  final providerHR = Provider.of<ProviderHR>(
    context,
    listen: false,
  );

  // Questo è il for per inserire tutte le entry di una data

  /*for (var heartRate in heartRates) {
    providerHR.insertHR(HREntity(
      '2023-06-26',
      timeStringToDouble(heartRate.time),
      heartRate.value,
    ));
  }*/

  //Qui ho messo i dati a mano per fare una singola entry
  var time = timeStringToDouble(heartRates[50].time);
  var value = heartRates[50].value;

  providerHR.insertHR(HREntity('2023-06-26', time, value));
}
