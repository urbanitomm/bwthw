import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:progetto_wearable/database/prepopulation.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const route = '/login/';
  static const routename = 'LoginPage';

  @override
  State<Login> createState() => _LoginPage();
}

class _LoginPage extends State<Login> {
  @override
  void initState() {
    super.initState();
    print('checking...');
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
    print('checked...');
  } //initState

  void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if (sp.getString('username') == '1234@5678.com') {
      //If 'username is set, push the HomePage
      print('case 1');
      _toDiaryPage(context);
    } //if
  } //_checkLogin

  Future<String> _loginUser(LoginData data) async {
    if (data.name == '1234@5678.com' && data.password == '123456') {
      final sp = await SharedPreferences.getInstance();
      sp.setString('username', data.name);

      return '';
    } else {
      return 'Wrong credentials';
    }
  }

  // _loginUser
  Future<String> _signUpUser(SignupData data) async {
    return 'To be implemented';
  }

  // _signUpUser
  Future<String> _recoverPassword(String email) async {
    return 'Recover password functionality needs to be implemented';
  }

  // _recoverPassword
  @override
  Widget build(BuildContext context) {
    print('Build login');
    return FlutterLogin(
      title: 'App_name',
      onLogin: _loginUser,
      onSignup: _signUpUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () async {
        _toDiaryPage(context);
      },
    );
  } // build

  //Navigation to go to the diary page
  void _toDiaryPage(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //If the user never wrote into the diary initialize the variable that tells the last time the user wrote
    if (sp.containsKey('lastEntryDate') == false) {
      //The string format is overall more compatible with other parts of the code
      sp.setString('lastEntryDate', getTodayDate());
      //Prepopulation of the database before the first login of the user
      await prepopulate(context);
      print('Populated');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Diary()));

      //If the user already has written in the diary they will go to the homepage
    } else if (sp.getString('lastEntryDate') == getTodayDate()) {
      print("Oggi ho gia scritto");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Homepage()));

      //If the user hasn't written into the diary the navigation will bring them to the diary
    } else {
      sp.setString('lastEntryDate', getTodayDate());
      print('"Oggi non ho ancora scritto"');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Diary()));
    }
  }
} // LoginScreen