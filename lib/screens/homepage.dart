import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/calendar.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:progetto_wearable/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';

  @override
  State<Homepage> createState() => _HomeState();
}

class _HomeState extends State<Homepage> {
  int _selIdx = 0;
  
  List<BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.show_chart),
      label: 'Data',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month),
      label: 'Diary',
    ),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selIdx = index;
    });
  }

  Widget _selectPage({
    required int index,
  }) {
    switch (index) {
      case 0:
      print('1');
        return Home();
      case 1:
      print('2');
        return Data();
      case 2:
      print('3');
        return Calendar(); 
        
      default:
        return Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage built');

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Stack(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text("Luca"),
                    accountEmail: Text("luca@virgilio.it"),
                    //TODO: aggiungere foto profilo
                    currentAccountPicture: CircleAvatar(
                    //backgroundImage: NetworkImage(
                    //"https://appmaking.co/wp-content/uploads/2021/08/appmaking-logo-colored.png"),
              ),)
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Options"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('App name'),
        //leading: Icon(Icons.menu),
        //leadingWidth: 100,
      ),
      bottomNavigationBar: BottomNavigationBar(
            items: navBarItems,
            currentIndex: _selIdx,
            onTap: _onItemTapped,),
      body: _selectPage(index: _selIdx),
    );
  } //build
} //HomePage