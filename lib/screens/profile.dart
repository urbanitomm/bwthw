import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';


class Profile extends StatelessWidget {
  static const route = '/profile/';
  static const routeDisplayName = 'ProfilePage';

  const Profile({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppbar(),
      drawer: MyDrawer(),
      body:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.face,
                  size: 30,
                  ),
                SizedBox(
                  height:30,
                ),
                Text(
                  'Profilo',
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
                ),
              ],),
          ],
        )
      ); 
  }
}