import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/repository/databaserepository.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:progetto_wearable/utils/funcs.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  static const route = '/diary/';
  static const routename = 'Diary';

  @override
  State<Diary> createState() => _DiaryState();
}
class _DiaryState extends State<Diary>  {

  //Variables that control the mood 
  //Booleans are easier to work with into the diary but we use a string to
  //store more efficiently the mood into the database
  bool happyPressed = false;
  bool neutralPressed = false;
  bool sadPressed = false;

  //Initialized as null
  String? entryMood;
  String? entryText;

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
    return Scaffold(
      appBar: const MyAppbar(),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "How do you feel today?",
              style: TextStyle(  
              fontSize: 18)),
              const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 60,
                  icon: Icon(
                    Icons.sentiment_very_satisfied,
                    color: happyPressed ? Colors.green : Colors.black,
                    ),
                  onPressed: () {
                    setState((){
                          happyPressed = true;
                          neutralPressed = false;
                          sadPressed = false;
                          entryMood = 'Happy';
                        });
                  },
                  ),
                IconButton(
                  iconSize: 60,
                  icon: Icon(
                    Icons.sentiment_neutral,
                    color: neutralPressed ? Colors.orange : Colors.black,
                    ),
                  onPressed: () {
                    setState((){
                          happyPressed = false;
                          neutralPressed = true;
                          sadPressed = false;
                          entryMood = 'Neutral';
                        });
                  },
                  ),                  
                IconButton(
                  iconSize: 60,
                  icon: Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: sadPressed ? Colors.red : Colors.black,
                    ),
                  onPressed: () {
                    setState((){
                          happyPressed = false;
                          neutralPressed = false;
                          sadPressed = true;
                          entryMood = 'Sad';
                        });
                  },
                  ),
          ]),
            const SizedBox(
              height: 100,
            ),
            Container(
              width: 300.0,
              child:
                TextField(
                  controller: textController,
                  maxLines: 4,
                  onChanged: (text) {  
                    entryText = text;  
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
                    suffixIcon:IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: (){
                      textController.clear();
                      }),
                    ),
                  )),
          
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: (){
                  entryCheck(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                child: const Text(
                  'Submit',
                  style: TextStyle(  
                    fontSize: 25)),  
                    ),
          ],
        ),
      ),
    );
  } //build

  
  void entryCheck(BuildContext context) async{
  
     if(entryMood == null) { //Snackbar for missing mood
      ScaffoldMessenger.of(context).showSnackBar(snackBarMood);

     }else if(entryText == '' || entryText == null){ //Snackbar for missing text
      ScaffoldMessenger.of(context).showSnackBar(snackBarText);
    
    }else{ //If everything is ok i record the entry into the database
    await Provider.of<DatabaseRepository>(context, listen: false)
                .insertDiaryentry(Diaryentry(getTodayDate(),entryText!, entryMood!));
    
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Homepage()), (route) => false);

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


