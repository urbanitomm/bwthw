import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/login.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  static const route = '/diary/';
  static const routename = 'Diary';

  @override
  State<Diary> createState() => _DiaryState();
}
class _DiaryState extends State<Diary>  {

  bool _happyPressed = false;
  bool _neutralPressed = false;
  bool _sadPressed = false;
  @override
  Widget build(BuildContext context) {
    print('Diary built');
    return Scaffold(
      appBar: MyAppbar(),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "How do you feel today?",
              style: TextStyle(  
              fontSize: 18)),
              SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 60,
                  icon: Icon(
                    Icons.sentiment_very_satisfied,
                    color: _happyPressed ? Colors.green : Colors.black,
                    ),
                  onPressed: () {
                    setState((){
                          _happyPressed = true;
                          _neutralPressed = false;
                          _sadPressed = false;
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
                    setState((){
                          _happyPressed = false;
                          _neutralPressed = true;
                          _sadPressed = false;
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
                    setState((){
                          _happyPressed = false;
                          _neutralPressed = false;
                          _sadPressed = true;
                        });
                  },
                  ),
          ]),
            SizedBox(
              height: 100,
            ),
            Container(
              width: 300.0,
              child:
                TextField(
                  maxLines: 4,
                  style: TextStyle(
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
                    contentPadding: EdgeInsets.symmetric(
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
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon:IconButton(
                      icon: Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: (){
                      //TO DO: cancellazione del contenuto text box
                      }),
                    ),
                  )),
          
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                child: Text(
                  'Submit',
                  style: TextStyle(  
                    fontSize: 25)),  
                    ),
          ],
        ),
      ),
    );
  } //build
} //HomePage