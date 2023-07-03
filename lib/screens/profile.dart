import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const route = '/profile/';
  static const routeDisplayName = 'ProfilePage';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isDarkModeEnabled = false; //default value

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  Future<void> loadPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      isDarkModeEnabled = sp.getBool('isDarkModeEnabled') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkModeEnabled
          ? ThemeData(
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark(
                primary: Colors.black,
                background: Colors.black,
                onBackground: Colors.black,
                secondary: Colors.blue,
              ),
            )
          : ThemeData(
              brightness: Brightness.light,
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(190, 71, 70, 70),
                background: Color.fromARGB(255, 0, 0, 0),
                onBackground: Colors.white,
                secondary: Colors.blue,
              ),
            ),
      home: Scaffold(
        appBar: const MyAppbar(),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Homepage()));
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: const Row(
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
                  height: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
