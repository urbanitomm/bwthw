import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progetto_wearable/models/hr.dart';
import 'package:progetto_wearable/models/restingHr.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:progetto_wearable/utils/funcs.dart';

class Data extends StatefulWidget {
  static const route = '/data/';
  static const routeDisplayName = 'DataPage';

  const Data({Key? key}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  //int aqi = 10;
  final Future<List<HeartRate>> _dataSourceFuture = _requestDataHR();
  List<HeartRate> heartRates = [];

  Future<void> _loadData() async {
    heartRates = await _dataSourceFuture;
    setState(() {});
    print('provaaaaa');
    //print the size of the list
    print(heartRates.length);
    //pritn the type of time
    print('type');
    print(heartRates[4].time.runtimeType);
    print('time string');
    print(heartRates[4].time);
    print('time double');
    print(timeStringToDouble(heartRates[4].time));

    //print('max value');
    //print(heartRates.reduce((curr, next) => curr.value > next.value ? curr : next));
    //heartRates.forEach((element) => print(element));
  }

  //chack the max value of the list of heartRates and print it

  //call the load data function
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //print the values of heartRates one by one

  //final  _dataSourceFuture = await _requestDataHR();

  //_DataState(this._dataSourceFuture, {Key? key}) : super(key: key);
  //print the values of _dataSourceFuture one by one
  //_dataSourceFuture.forEach((element) => print(element));
  /*
  @override
  void initState() {
    _dataSourceFuture = _requestDataHR();
  }
  */
  //print the

  //DateTime day = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        minX: 0,
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.black,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.blue, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            //LineChartBarData(spots: heartRates.map((e) => FlSpot(double.tryParse(e.time) ?? 0, e.value)).toList(),)
            spots: heartRates
                .map((e) =>
                    FlSpot(timeStringToDouble(e.time), e.value.toDouble()))
                .toList(),
            isCurved: true,
            color: Colors.blue,
          )
          //dotData: FlDotData(show: true))
        ]));
    //create a an elevated button
    /*return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                await graph();
              },
              child: Text('Get HR')),
        ],
      )),
    );*/
    /*return Scaffold(
      body: FutureBuilder<List<HeartRate>>(
        future: _dataSourceFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            print('is not null');

            return SfCartesianChart(
                title: ChartTitle(text: 'HR Chart'),
                //legend: Legend(isVisible: true),
                series: <ChartSeries>[
                  LineSeries<HeartRate, String>(
                    dataSource: snapshot.data!,
                    xValueMapper: (HeartRate hr, _) => hr.time,
                    yValueMapper: (HeartRate hr, _) => hr.value,
                  )
                ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
    */
    /*return Scaffold(
      //Appbar and the drawer are already in the homepage
      body: SingleChildScrollView(
        child: SizedBox(
          width: 200.0,
          height: 200.0,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*ElevatedButton(
                    onPressed: () async {
                      final result = await _authorize();
                      final message = result == 200
                          ? 'You have been authorized'
                          : 'You have been denied access';
                      final data = await _requestDataHR();
                      //print('ok');
                      print(data);
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(message)));
                    },
                    child: Text('Get HR')),
                              ElevatedButton(
                    onPressed: () async {
                      final result = await _authorize();
                      final message = result == 200
                          ? 'You have been authorized'
                          : 'You have been denied access';
                      final data = await _requestDataRestingHR();
                      //print('ok');
                      print(data);
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(message)));
                    },
                    child: Text('Get RESTING HR')), */
                    Scaffold(
                      body: FutureBuilder<List<HeartRate>>(
                        future: _dataSourceFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            print('is not null');
                            return SfCartesianChart(
                                title: ChartTitle(text: 'HR Chart'),
                                series: <ChartSeries>[
                                  LineSeries<HeartRate, String>(
                                    dataSource: snapshot.data!,
                                    xValueMapper: (HeartRate hr, _) => hr.time,
                                    yValueMapper: (HeartRate hr, _) => hr.value,
                                  )
                                ]);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );*/
    // Try with another chart
  }
}

Future<void> graph() async {
  final dataSourceFuture = await _requestDataHR();
  print('inside graph');

  //print the size of the list
  print(dataSourceFuture.length);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SfCartesianChart(
        series: <ChartSeries>[
          LineSeries<HeartRate, String>(
            dataSource: dataSourceFuture,
            xValueMapper: (HeartRate hr, _) => hr.time,
            yValueMapper: (HeartRate hr, _) => hr.value,
          )
        ],
      )),
    );
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

  //create a variable that is a week before the current date
  final url = Impact.baseUrl + Impact.hrEndpoint;
  final headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

  //Send request
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );
  //print(Impact.startDate);
  //print(url);
  print(response.statusCode);
  //Check response
  //List<HeartRate> result_hr = [];
  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);

    for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
      //print(decodedResponse['data']['data'][i]);
      resultHr.add(HeartRate.fromJson(decodedResponse['data']['data'][i]));
      //print(result_hr[i]);
    }
  } else {
    print(response.statusCode);
  }
  print('dimensione prima di passare:');
  print(resultHr.length);

  // print the result_hr elements

  return resultHr;
}

Future<List<RestingHeartRate>> _requestDataRestingHR() async {
  //initialize the result
  List<RestingHeartRate> resultRestinghr = [];

  //Get the access token from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString('access');

  //If the token is expired, refresh it
  if (JwtDecoder.isExpired(accessToken!)) {
    await _refreshToken();
    accessToken = prefs.getString('access');
  }

  //Create request

  //create a variable that is a week before the current date
  final url = Impact.baseUrl + Impact.hrEndpoint;
  final headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

  //Send request
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );
  //print(Impact.startDate);
  //print(url);
  print(response.statusCode);
  //Check response

  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);

    for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
      //print(decodedResponse['data']['data'][i]);
      resultRestinghr
          .add(RestingHeartRate.fromJson(decodedResponse['data']['data'][i]));
      //print(result_RestingHR[i]);
    }
  } else {
    print(response.statusCode);
  }
  return resultRestinghr;
}
