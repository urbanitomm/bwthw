import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/repository/localizatioProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/screens/map.dart';
import 'package:app_settings/app_settings.dart';

class Options extends StatelessWidget {
  const Options({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OptionS(),
    );
  }
}

class OptionS extends StatefulWidget {
  const OptionS({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OptionState();
}

class OptionState extends State<OptionS> {
  bool isDarkModeEnabled = true; //default value
  bool isGeolocalizationEnabled = false; //default value
  LocationPermission permission = LocationPermission.always;
  bool isConditionAccepted = true; //default value

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      isDarkModeEnabled = sp.getBool('isDarkModeEnabled') ?? false;
      isGeolocalizationEnabled =
          Provider.of<GeolocationProvider>(context, listen: false)
              .serviceEnabled1;
      permission =
          Provider.of<GeolocationProvider>(context, listen: false).permission1;
      isConditionAccepted = sp.getBool('isConditionAccepted') ?? true;
    });
  }

  Future<void> _saveThemePreference(String variable, bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(variable, value);
  }

  void openLocalizationSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  Future<void> logout(bool value) async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.yellow, // Set the desired background color
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Confirmation'),
                      const SizedBox(height: 16.0),
                      const Text('Are you sure you want to log out?'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isConditionAccepted = true;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color.fromARGB(255, 129, 7, 143),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Mark the onPressed callback as async
                        final sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.remove("username");
                        print('SP cleaned');
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const Login()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          color: Color.fromARGB(255, 129, 7, 143),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Build optionPage');
    return MaterialApp(
      home: Scaffold(
        appBar: const MyAppbar(),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: Column(
          children: <Widget>[
            SwitchListTile(
              value: isDarkModeEnabled,
              onChanged: (bool value1) {
                setState(() {
                  isDarkModeEnabled = value1;
                });
                _saveThemePreference('isDarkModeEnabled', value1);
              },
              title: const Text('Theme color'),
              subtitle: const Text('Switch between light and dark mode'),
            ),
            const Divider(height: 0),
            SwitchListTile(
              value: isGeolocalizationEnabled,
              onChanged: (bool value3) {
                setState(() {
                  if (value3) {
                    Provider.of<GeolocationProvider>(context, listen: false)
                        .enableGeolocalizatio(true, LocationPermission.always);
                    isGeolocalizationEnabled = value3;

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: Colors
                              .deepOrange, // Set the desired background color
                          title: const Text('Activate the settings'),
                          content: const Text(
                            'You should activate geolocation to access this page',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                openLocalizationSettings();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Provider.of<GeolocationProvider>(context, listen: false)
                        .disableGeolocalizatio(
                            false, LocationPermission.denied);
                    isGeolocalizationEnabled = value3;
                  }
                });
              },
              title: const Text('Geolocation'),
              subtitle: const Text('Switch on and off geolocation'),
            ),
            const Divider(height: 0),
            SwitchListTile(
              value: isConditionAccepted,
              onChanged: (bool value4) {
                setState(() {
                  isConditionAccepted = true;
                });
                _saveThemePreference('isConditionAccepted', true);
                if (!value4) {
                  logout(value4);
                }
              },
              title: const Text('Privacy Policy'),
              subtitle: const Text(
                  'You can only use the app if you agree with the privacy policy. If you disagree, you will be logged out.'),
            ),
            const Divider(height: 0),
          ],
        ),
      ),
      theme: isDarkModeEnabled
          ? ThemeData(
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark(
                primary: Colors.black,
                background: Colors.black,
                onBackground: Colors.black,
                secondary: Colors.yellow,
              ),
            )
          : ThemeData(
              brightness: Brightness.light,
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(190, 71, 70, 70),
                background: Color.fromARGB(255, 0, 0, 0),
                onBackground: Colors.white,
                secondary: Colors.yellow,
              ),
            ),
    );
  }
}
