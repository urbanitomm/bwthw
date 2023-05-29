import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/profile.dart';
import 'package:progetto_wearable/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              onTap: () async{
                //Al logout pulisco le shared preferences 
                SharedPreferences sp = await SharedPreferences.getInstance();
                await sp..remove("username");
                print('SP cleaned');
                _toLoginPage(context);
              }
            ),
          ],
        ),
      );
      
  }
  
  void _toLoginPage(BuildContext context) async{
    //Unset the 'username' filed in SharedPreference 
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    //Then pop the HomePage
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Login()), (route) => false);
  }//_toCalendarPage
}


