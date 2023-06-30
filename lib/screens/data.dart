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
      body: Text(
        'Grafico',
        style: TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}
