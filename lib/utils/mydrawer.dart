import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/home.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:progetto_wearable/screens/login.dart';
import 'package:progetto_wearable/screens/profile.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Stack(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text("Luca"),
                    accountEmail: Text("luca@virgilio.it"),
                    //TODO: aggiungere foto profilo
                    currentAccountPicture: CircleAvatar(
                    //backgroundImage: NetworkImage(
                    //"https://appmaking.co/wp-content/uploads/2021/08/appmaking-logo-colored.png"),
              ),)
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Options"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      );
  }
}


