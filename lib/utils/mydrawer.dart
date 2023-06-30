import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/profile.dart';
import 'package:progetto_wearable/screens/login.dart';
import 'package:progetto_wearable/screens/Options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Stack(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text("Luca"),
                  accountEmail: Text("luca@virgilio.it"),
                  //TODO: aggiungere foto profilo
                  currentAccountPicture: CircleAvatar(
                      //backgroundImage: NetworkImage(
                      //"https://appmaking.co/wp-content/uploads/2021/08/appmaking-logo-colored.png"),
                      ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text("Profile"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Options"),
            onTap: () {},
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                //Logging out the shared preferences for the profile are deleted
                SharedPreferences sp = await SharedPreferences.getInstance();
                await sp.remove("username");
                print('SP cleaned');
                _toLoginPage(context);
              }),
        ],
      ),
    );
  }

  void _toLoginPage(BuildContext context) async {
    //Unset the 'username' filed in SharedPreference
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    //Then pop the HomePage
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => Login()), (route) => false);
  } //_toCalendarPage
}
