import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/contacts.dart';
import 'package:progetto_wearable/screens/selfReport.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';
  @override
  Homestate createState() => Homestate();
}

class Homestate extends State<Home> {
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
    print('HomePage built');

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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("You already submitted today's entry",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelfReport()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        fixedSize: const Size(200, 70),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: const Text('Self report',
                        style: TextStyle(fontSize: 25))),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Contacts()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      fixedSize: const Size(200, 70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Ask for help',
                      style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
          ),
        ));
  } //build
} //HomePage