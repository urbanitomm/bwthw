import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:progetto_wearable/database/prepopulation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const route = '/login/';
  static const routename = 'LoginPage';

  @override
  State<Login> createState() => _LoginPage();
}

class _LoginPage extends State<Login> {
  bool? isTermsAccepted = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
    if (data.name == '1234@5678.com' &&
        data.password == '123456' &&
        isTermsAccepted == true) {
      final sp = await SharedPreferences.getInstance();
      sp.setString('username', data.name);

      return '';
    } else if (data.name != '1234@5678.com' || data.password != '123456') {
      return 'Wrong credentials';
    } else {
      return 'you must accept the terms of service';
    }
  }

  Future<void> _saveTermPreference(bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isConditionAccepted', value);
  }

  // _signUpUser
  Future<String> _recoverPassword(String email) async {
    return 'Recover password functionality needs to be implemented';
  }

  // _recoverPassword
  @override
  Widget build(BuildContext context) {
    print('Build login');

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FlutterLogin(
              title: 'AlcoCare',
              onLogin: _loginUser,
              onRecoverPassword: _recoverPassword,
              onSubmitAnimationCompleted: () async {
                _toDiaryPage(context);
              },
              theme: LoginTheme(
                primaryColor: const Color.fromARGB(255, 129, 7, 143),
                accentColor: Colors.yellow,
                errorColor: Colors.deepOrange,
                cardTheme: CardTheme(
                  color: const Color.fromARGB(255, 88, 170, 236),
                  elevation: 5,
                  margin: const EdgeInsets.only(top: 15),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton(
              onPressed: () async {
                _googleSignIn.signIn().then((value) {
                  String userName = value!.displayName!;
                  print(userName);
                  _toDiaryPage(context);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png', // Replace with the path to your Google logo image
                    height: 24, // Set the height of the logo
                  ),
                  const SizedBox(
                      width: 8), // Add some spacing between the logo and text
                  const Text('Login with Google',
                      style: TextStyle(color: Colors.black)),
                ],
              ),
              //child: const Text('Login with Google'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Set the background color of the button
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*const Text(
                'To login you must accept our terms of service',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                ),
              ),*/
              RichText(
                text: TextSpan(
                  text: 'To login you must accept our ',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                  ),
                  children: [
                    TextSpan(
                      text: 'terms of service',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          const url =
                              'https://docs.google.com/document/d/1G4lgDh-cM-uvIU6579IitnrXjhCMJCT_2RI49GFtKUw/edit?usp=sharing';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: isTermsAccepted,
                onChanged: (bool? value) {
                  setState(() {
                    isTermsAccepted = value!;
                  });
                  _saveTermPreference(isTermsAccepted!);
                },
              ),
            ],
          ),
        ],
      ),
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
    }
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signInSilently();
    if (googleUser != null) {
      // If the user is logged in with Google, navigate to the homepage
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Homepage()));
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