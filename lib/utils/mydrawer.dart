import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/profile.dart';
import 'package:progetto_wearable/screens/login.dart';
import 'package:progetto_wearable/screens/Options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/screens/prova.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.yellow,
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
            leading: const Icon(
              Icons.account_box,
              color: Color.fromARGB(255, 129, 7, 143),
              size: 45,
            ),
            title: const Text("PROFILE", style: TextStyle(fontSize: 17)),
            selectedColor: Colors.yellow,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 129, 7, 143),
              size: 50,
            ),
            title: const Text("OPTIONS", style: TextStyle(fontSize: 17)),
            selectedColor: Colors.yellow,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Options()));
            },
          ),
          ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 129, 7, 143),
                size: 50,
              ),
              title: const Text("LOGOUT", style: TextStyle(fontSize: 17)),
              selectedColor: Colors.yellow,
              onTap: () async {
                //Logging out the shared preferences for the profile are deleted
                SharedPreferences sp = await SharedPreferences.getInstance();
                await sp.remove("username");
                print('SP cleaned');
                _toLoginPage(context);
              }),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 129, 7, 143),
              size: 50,
            ),
            title: const Text("PROVA", style: TextStyle(fontSize: 17)),
            selectedColor: Colors.yellow,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const prova()));
            },
          ),
        ],
      ),
    );
  }

  void _toLoginPage(BuildContext context) async {
    //Unset the 'username' filed in SharedPreference
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    //Then pop the HomePage
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const Login()), (route) => false);
  } //_toCalendarPage
}
