import 'package:flutter/material.dart';
import 'package:progetto_wearable/data.dart';
import 'package:progetto_wearable/test_home.dart';
import 'package:progetto_wearable/homepage.dart';
import 'package:progetto_wearable/diary.dart';
import 'package:progetto_wearable/login.dart';
import 'package:progetto_wearable/data.dart';

void main() {
  runApp(MyApp());
} //main

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Diary(),
    );
  } //build
}//MyApp