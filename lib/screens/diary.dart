import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/repository/databaseRepository.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  static const route = '/diary/';
  static const routename = 'Diary';

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
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

  //Variables that control the mood
  //Booleans are easier to work with into the diary but we use a string to
  //store more efficiently the mood into the database
  bool _happyPressed = false;
  bool _neutralPressed = false;
  bool _sadPressed = false;

  //Initialized as null
  String? _entryMood;
  String? _entryText;

  //Shown if the user does not fill the entry
  final snackBarText = const SnackBar(
    content: Text('You should write something'),
  );
  final snackBarMood = const SnackBar(
    content: Text('You should pick a mood'),
  );

  var textController = TextEditingController();

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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("How do you feel today?",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    iconSize: 60,
                    icon: Icon(
                      Icons.sentiment_very_satisfied,
                      color: _happyPressed ? Colors.green : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _happyPressed = true;
                        _neutralPressed = false;
                        _sadPressed = false;
                        _entryMood = 'Happy';
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 60,
                    icon: Icon(
                      Icons.sentiment_neutral,
                      color: _neutralPressed ? Colors.orange : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _happyPressed = false;
                        _neutralPressed = true;
                        _sadPressed = false;
                        _entryMood = 'Neutral';
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 60,
                    icon: Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: _sadPressed ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _happyPressed = false;
                        _neutralPressed = false;
                        _sadPressed = true;
                        _entryMood = 'Sad';
                      });
                    },
                  ),
                ]),
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                    width: 300.0,
                    child: TextField(
                      controller: textController,
                      maxLines: 4,
                      onChanged: (text) {
                        _entryText = text;
                      },
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'Enter your text',
                        hintStyle: TextStyle(
                          fontSize: 16.0,
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
                              textController.clear();
                            }),
                      ),
                    )),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    _entryCheck(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      fixedSize: const Size(200, 70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Submit',
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 129, 7, 143))),
                ),
              ],
            ),
          ),
        ));
  } //build

  void _entryCheck(BuildContext context) async {
    if (_entryMood == null) {
      //Snackbar for missing mood
      ScaffoldMessenger.of(context).showSnackBar(snackBarMood);
    } else if (_entryText == '' || _entryText == null) {
      //Snackbar for missing text
      ScaffoldMessenger.of(context).showSnackBar(snackBarText);
    } else {
      //If everything is ok i record the entry into the database
      await Provider.of<DatabaseRepository>(context, listen: false)
          .insertDiaryentry(
              Diaryentry(getTodayDate(), _entryText!, _entryMood!));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Homepage()),
          (route) => false);
    }
  }
} //HomePage

/*
DA METTERE SE CI SONO PROBLEMI

//Check ulteriore nel caso l'utente finisce accidentalmente nel 
  void _checkLegitimacy(context)async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getBool('firstEntryOfToday')!){
      sp.setBool('firstEntryOfToday', false);
    }else{
      print('UNINTENDED ACCESS IN THE DIARY PAGE!!!');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    }
  }
  */
