import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/login.dart';
class Contacts extends StatelessWidget {
  Contacts({Key? key}) : super(key: key);

  static const route = '/contacts/';
  static const routename = 'Contacts';

  @override
  Widget build(BuildContext context) {
    print('Diary built');

    return Scaffold(
      appBar: MyAppbar(),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.medical_services),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dott.ssa Rossi",
                      style: TextStyle(  
                      fontSize: 20)
                    ),
                    Text(
                      "333 444555666",
                      style: TextStyle(  
                      fontSize: 18)
                    ),
                ],
                ),
              Icon(Icons.call),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.person),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Mamma",
                      style: TextStyle(  
                      fontSize: 20)
                    ),
                    Text(
                      "345 87654321",
                      style: TextStyle(  
                      fontSize: 18)
                    ),
                ],
                ),
                Icon(Icons.call),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.person),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Marco",
                      style: TextStyle(  
                      fontSize: 20)
                    ),
                    Text(
                      "369 12345678",
                      style: TextStyle(  
                      fontSize: 18)
                    ),
                ],
                ),
                Icon(Icons.call),
              ],
            ),
          ],
        ),
      ),
    );
  } //build
} //HomePage