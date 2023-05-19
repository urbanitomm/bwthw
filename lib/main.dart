import 'package:flutter/material.dart';
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