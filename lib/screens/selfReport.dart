import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/database/entities/report.dart';
import 'package:progetto_wearable/repository/providerDataBaseSR.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:provider/provider.dart';

class SelfReport extends StatefulWidget {
  const SelfReport({Key? key}) : super(key: key);

  static const route = '/selfreport/';
  static const routename = 'SelfReport';
  @override
  SelfReportState createState() => SelfReportState();
}

class SelfReportState extends State<SelfReport> {
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
    //One controller for each textfield
    var textController1 = TextEditingController();
    var textController2 = TextEditingController();
    var textController3 = TextEditingController();

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
        resizeToAvoidBottomInset: false,
        appBar: const MyAppbar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            );
          },
          child: Icon(Icons.arrow_back),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Fill all fields", style: TextStyle(fontSize: 22)),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: textController1,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'How much alcohol did you consume?',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: () {
                        textController1.clear();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 300.0,
                child: TextField(
                  controller: textController2,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Where did you consume it?',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: () {
                        textController2.clear();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 300.0,
                child: TextField(
                  controller: textController3,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'When did you consume it?',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: () {
                        textController3.clear();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  insertData(textController1.text, textController2.text,
                      textController3.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> insertData(
    String text1,
    String text2,
    String text3,
  ) async {
    final mergedInput = '$text1\n$text2\n$text3';

    await Provider.of<SelfReportProvider>(context, listen: false)
        .insertReport(Report(getTodayDate(), mergedInput));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }
}
