import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/utils/funcs.dart';

class Contacts extends StatelessWidget {
  const Contacts({Key? key}) : super(key: key);

  static const route = '/contacts/';
  static const routename = 'Contacts';

  @override
  Widget build(BuildContext context) {
    print('Diary built');

    return Scaffold(
      appBar: const MyAppbar(),
      drawer: const MyDrawer(),
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
                    Text(
                      "Dott. Rossi",
                      style: TextStyle(  
                      fontSize: 20)
                    ),
                    Text(
                      "333 44455566",
                      style: TextStyle(  
                      fontSize: 18)
                    ),
                ],
                ),
              IconButton(
                  iconSize: 25,
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                    ),
                  onPressed: () async{
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
                    Text(
                      "Mamma",
                      style: TextStyle(  
                      fontSize: 20)
                    ),
                    Text(
                      "345 87654321",
                      style: TextStyle(  
                      fontSize: 18)
                    ),
                ],
                ),
                IconButton(
                  iconSize: 25,
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                    ),
                  onPressed: () async{
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
                    Text(
                      "Marco",
                      style: TextStyle(  
                      fontSize: 20)
                    ),
                    Text(
                      "369 12345678",
                      style: TextStyle(  
                      fontSize: 18)
                    ),
                ],
                ),
                IconButton(
                  iconSize: 25,
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                    ),
                  onPressed: () async{
                    call("36912345678");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  } //build
} //HomePage
