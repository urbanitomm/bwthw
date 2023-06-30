import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/login.dart';

class Options extends StatelessWidget {
  const Options({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  bool isMonitoringEnabled = true; //default value
  bool isGeolocalizationEnabled = true; //default value
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
      isMonitoringEnabled = sp.getBool('isMonitoringEnabled') ?? true;
      isGeolocalizationEnabled = sp.getBool('isGeolocalizationEnabled') ?? true;
      isConditionAccepted = sp.getBool('isConditionAccepted') ?? true;
    });
  }

  Future<void> _saveThemePreference(String variable, bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(variable, value);
  }

  Future<void> logout(bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("username");
    print('SP cleaned');
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => Login()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    print('Build optionPage');
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppbar(),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            );
          },
          child: Icon(Icons.arrow_back),
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
              value: isMonitoringEnabled,
              onChanged: (bool value2) {
                setState(() {
                  isMonitoringEnabled = value2;
                });
                _saveThemePreference('isMonitoringEnabled', value2);
              },
              title: const Text('Monitoring'),
              subtitle:
                  const Text('Switch on and off the monitoring on your fitbit'),
            ),
            const Divider(height: 0),
            SwitchListTile(
              value: isGeolocalizationEnabled,
              onChanged: (bool value3) {
                setState(() {
                  isGeolocalizationEnabled = value3;
                });
                _saveThemePreference('isGeolocalizationEnabled', value3);
              },
              title: const Text('Geolocation'),
              subtitle: const Text('Switch on and off geolocation'),
            ),
            const Divider(height: 0),
            SwitchListTile(
              value: isConditionAccepted,
              onChanged: (bool value4) {
                setState(() {
                  isConditionAccepted = value4;
                });
                _saveThemePreference('isConditionAccepted', value4);
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
                secondary: Colors.blue,
              ),
            )
          : ThemeData(
              brightness: Brightness.light,
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(190, 71, 70, 70),
                background: Color.fromARGB(255, 0, 0, 0),
                onBackground: Colors.white,
                secondary: Colors.blue,
              ),
            ),
    );
  }
}
