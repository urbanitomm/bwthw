import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class Data extends StatelessWidget {
  static const route = '/data/';
  static const routeDisplayName = 'DataPage';

  Data({Key? key}) : super(key: key);

  int aqi = 10;
  DateTime day = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Non è necessario importare appbar e drawer perchè sono gia in homeapge
            body:
              const Text(
                'Grafico',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),);
    
  }


}