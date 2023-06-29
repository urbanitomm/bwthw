import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/contacts.dart';
import 'package:progetto_wearable/screens/selfReport.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    print('HomePage built');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You already submitted today's entry",
              style: TextStyle(  
              fontSize: 18)),

            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SelfReport()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  fixedSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                child: const Text(
                  'Self report',
                  style: TextStyle(  
                    fontSize: 25))),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Contacts()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                child: const Text(
                  'Ask for help',
                  style: TextStyle(  
                    fontSize: 25)),  
                    ),
          ],
        ),
      ),
    );
  } //build
} //HomePage