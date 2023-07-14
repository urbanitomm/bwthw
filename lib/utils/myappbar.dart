import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'AlcoCare',
            style: TextStyle(
                color: Colors.yellow,
                letterSpacing: 3,
                fontSize: 35,
                //fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
          ),
          Image.asset(
            'assets/images/transparent_logo.png',
            height: 50,
            width: 50,
          ),
        ],
      ),
      shadowColor: Color.fromARGB(255, 129, 7, 143),

      //leading: Icon(Icons.menu),
      //leadingWidth: 100,
    );
  }
}
