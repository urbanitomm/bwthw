import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/screens/test_home.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/home.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:progetto_wearable/screens/login.dart';

void main() {
  runApp(MyApp());
} //main

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Login(),
    );
  } //build
}//MyApp