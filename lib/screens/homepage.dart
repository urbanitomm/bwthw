import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/calendar.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/screens/home.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';

  @override
  State<Homepage> createState() => _HomeState();
}

//THe homepage controls the bottom navigation bar and handle navigation
//for the main screens

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

//Tapping on the bottom navigation page the user can navigate
//between the pages
  Widget _selectPage({
    required int index,
  }) {
    switch (index) {
      case 0:
        print('1');
        return const Home();
      case 1:
        print('2');
        return Data();
      case 2:
        print('3');
        return const Calendar();

      default:
        return const Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage built');

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: const MyAppbar(),
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItems,
        currentIndex: _selIdx,
        onTap: _onItemTapped,
      ),
      body: _selectPage(index: _selIdx),
    );
  } //build
} //HomePage