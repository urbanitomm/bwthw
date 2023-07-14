import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/profile.dart';
import 'package:progetto_wearable/screens/login.dart';
import 'package:progetto_wearable/screens/Options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/screens/map.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Drawer(child: SizedBox());
        }

        final sp = snapshot.data!;
        final name = sp.getString('name') ?? 'Giacomo';
        final surname = sp.getString('surname') ?? 'Cappon';
        final email = sp.getString('email') ?? '1234@5678.com';
        final isGoogleUser = sp.getBool('isGoogleUser') ?? false;
        final googleName = sp.getString('Google_name') ?? '';
        final googleEmail = sp.getString('Google_email') ?? '';
        final photoUrl = sp.getString('photoUrl') ?? '';
        final profilePicturePath = sp.getString('profilePicture');
        final drawerPicture =
            profilePicturePath != null ? File(profilePicturePath) : null;
        /*final drawerPicture =
            isGoogleUser && photoUrl.isEmpty && profilePicturePath != null
                ? File(profilePicturePath)
                : profilePicturePath != null
                    ? File(profilePicturePath)
                    : (photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : AssetImage('assets/images/img.jpg'));*/

        return Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
                child: Stack(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: isGoogleUser
                          ? Text(googleName)
                          : Text('$name $surname'),
                      accountEmail:
                          isGoogleUser ? Text(googleEmail) : Text('$email'),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: drawerPicture != null
                            ? (drawerPicture is File
                                ? FileImage(drawerPicture)
                                : drawerPicture) as ImageProvider<Object>
                            : const AssetImage('assets/images/img.jpg'),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_box,
                  color: Color.fromARGB(255, 129, 7, 143),
                  size: 45,
                ),
                title: const Text("PROFILE", style: TextStyle(fontSize: 17)),
                selectedColor: Colors.yellow,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.place,
                  color: Color.fromARGB(255, 129, 7, 143),
                  size: 50,
                ),
                title: const Text("MAPS", style: TextStyle(fontSize: 17)),
                selectedColor: Colors.yellow,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MapView()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color.fromARGB(255, 129, 7, 143),
                  size: 50,
                ),
                title: const Text("OPTIONS", style: TextStyle(fontSize: 17)),
                selectedColor: Colors.yellow,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Options()));
                },
              ),
              ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 129, 7, 143),
                    size: 50,
                  ),
                  title: const Text("LOGOUT", style: TextStyle(fontSize: 17)),
                  selectedColor: Colors.yellow,
                  onTap: () async {
                    //Logging out the shared preferences for the profile are deleted
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    await sp.remove("username");
                    await sp.remove("name");
                    await sp.remove("surname");
                    await sp.remove("email");
                    await sp.remove("isGoogleUser");
                    await sp.remove("Google_name");
                    await sp.remove("Google_email");
                    await sp.remove("photoUrl");
                    await sp.remove("profilePicture");

                    print('SP cleaned');
                    _toLoginPage(context);
                  }),
            ],
          ),
        );
      },
    );
  }
}

void _toLoginPage(BuildContext context) async {
  //Unset the 'username' filed in SharedPreference
  final sp = await SharedPreferences.getInstance();
  sp.remove('username');

  //Then pop the HomePage
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_) => const Login()), (route) => false);
} //_toCalendarPage
//}