import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/home.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:progetto_wearable/screens/login.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text('App name'),
        //leading: Icon(Icons.menu),
        //leadingWidth: 100,
      );
  }
}
