import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/screens/homepage.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  static const route = '/contacts/';
  static const routename = 'Contacts';
  @override
  ConctatState createState() => ConctatState();
}

class ConctatState extends State<Contacts> {
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
    print('Diary built');

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: isDarkModeEnabled
            ? ThemeData(
                brightness: Brightness.dark,
                colorScheme: const ColorScheme.dark(
                  primary: Colors.black,
                  background: Colors.black,
                  onBackground: Colors.black,
                  secondary: Colors.yellow,
                ),
              )
            : ThemeData(
                brightness: Brightness.light,
                colorScheme: const ColorScheme.light(
                  primary: Color.fromARGB(190, 71, 70, 70),
                  background: Color.fromARGB(255, 0, 0, 0),
                  onBackground: Colors.white,
                  secondary: Colors.yellow,
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
          body: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(Icons.medical_services),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Dott. Rossi", style: TextStyle(fontSize: 20)),
                        Text("333 44455566", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    IconButton(
                        iconSize: 25,
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          call("33344455566");
                        }),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(Icons.person),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Mamma", style: TextStyle(fontSize: 20)),
                        Text("345 87654321", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    IconButton(
                        iconSize: 25,
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          call("34587654321");
                        }),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(Icons.person),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Marco", style: TextStyle(fontSize: 20)),
                        Text("369 12345678", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    IconButton(
                      iconSize: 25,
                      icon: const Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        call("36912345678");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  } //build
} //HomePage
