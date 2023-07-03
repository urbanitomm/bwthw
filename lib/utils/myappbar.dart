import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'AlcoCare',
        style: TextStyle(
          color: Colors.yellow,
          letterSpacing: 3,
          fontSize: 35,
        ),
      ),
      shadowColor: Color.fromARGB(255, 129, 7, 143),
      //leading: Icon(Icons.menu),
      //leadingWidth: 100,
    );
  }
}
