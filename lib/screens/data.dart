import 'package:flutter/material.dart';


class Data extends StatelessWidget {
  static const route = '/data/';
  static const routeDisplayName = 'DataPage';

  Data({Key? key}) : super(key: key);

  int aqi = 10;
  DateTime day = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //Appbar and the drawer are already in the homepage
            body:
              Text(
                'Grafico',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),);
    
  }


}