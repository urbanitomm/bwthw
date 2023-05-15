import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/screens/test_home.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/login.dart';
class Diary extends StatelessWidget {
  Diary({Key? key}) : super(key: key);

    static const route = '/dairy/';
  static const routename = 'Diary';

  @override
  Widget build(BuildContext context) {
    print('Diary built');

    return Scaffold(
      appBar: AppBar(
        title: Text('App name'),
        leading: Icon(Icons.menu),
        leadingWidth: 100,
      ),
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
                  icon: const Icon(Icons.sentiment_very_satisfied),
                  onPressed: () {},
                  ),
                IconButton(
                  iconSize: 60,
                  icon: const Icon(Icons.sentiment_neutral),
                  onPressed: () {},
                  ),                  
                IconButton(
                  iconSize: 60,
                  icon: const Icon(Icons.sentiment_very_dissatisfied),
                  onPressed: () {},
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
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