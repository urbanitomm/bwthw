import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progetto_wearable/models/hr.dart';
import 'package:progetto_wearable/models/restingHr.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data extends StatefulWidget {
  static const route = '/data/';
  static final routeDisplayName = 'DataPage';

  Data({Key? key}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  int aqi = 10;

  //DateTime day = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar and the drawer are already in the homepage
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
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
              child: Text('Get RESTING HR'))
        ]),
      ),
    );
  }
}

// This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
Future<int?> _authorize() async {
  //Create request
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

Future<List<HeartRate>?> _requestDataHR() async {
  //initialize the result
  List<HeartRate>? result_hr;

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
    List<HeartRate> result_hr = [];
    for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
      //print(decodedResponse['data']['data'][i]);
      result_hr.add(HeartRate.fromJson(decodedResponse['data']['data'][i]));
      print(result_hr[i]);
    }
  } else {
    print(response.statusCode);
  }
  return result_hr;
}

Future<List<RestingHeartRate>?> _requestDataRestingHR() async {
  //initialize the result
  List<RestingHeartRate>? result_RestingHR;

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
    List<RestingHeartRate> result_RestingHR = [];
    for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
      //print(decodedResponse['data']['data'][i]);
      result_RestingHR
          .add(RestingHeartRate.fromJson(decodedResponse['data']['data'][i]));
      print(result_RestingHR[i]);
    }
  } else {
    print(response.statusCode);
  }
  return result_RestingHR;
}
