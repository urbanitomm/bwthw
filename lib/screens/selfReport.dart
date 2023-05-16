import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/login.dart';

class SelfReport extends StatelessWidget {
  SelfReport({Key? key}) : super(key: key);

    static const route = '/selfreport/';
  static const routename = 'SelfReport';

  @override
  Widget build(BuildContext context) {
    print('Selfreport built');

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
              "Fill all fields",
              style: TextStyle(  
              fontSize: 18)),
              SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
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
                    hintText: 'How much alcohol did you consume?',
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
                    hintText: 'Where did you consume it?',
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
                    hintText: 'When did you consume it??',
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
              height: 30,
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