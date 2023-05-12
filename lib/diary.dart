import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diary extends StatelessWidget {
  Diary({Key? key}) : super(key: key);

  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    print('HomePage_temp built');

    return Scaffold(
      appBar: AppBar(
        title: Text('App name'),
        //leading: Icon(Icons.menu),
        //leadingWidth: 100,
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
              ]
            ),
            SizedBox(
              height: 100,
            ),
                TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
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
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey[400],
                    ),
                    suffixIcon:Icon(
                      Icons.clear,
                      color: Colors.grey[400],
                    ),)),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: (){},
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