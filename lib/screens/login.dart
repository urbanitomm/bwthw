import 'package:flutter/material.dart';
import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:progetto_wearable/screens/home.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/repository/databaseRepository.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:progetto_wearable/database/prepopulation.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const route = '/login/';
  static const routename = 'LoginPage';

  @override
  State<Login> createState() => _LoginPage();
}
class _LoginPage extends State<Login>{
  
    @override
  void initState() {
    super.initState();
    print('checking...');
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
    print('checked...');
  }//initState

  void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if(sp.getString('username') == '1234@5678.com'){
      //If 'username is set, push the HomePage
      print('case 1');
      _toDiaryPage(context);
    }//if
  }//_checkLogin

  Future<String> _loginUser(LoginData data) async {
    if(data.name == '1234@5678.com' && data.password == '123456'){

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
      onSubmitAnimationCompleted: () async{
        _toDiaryPage(context);
      },
    );
  } // build

  //Codice per passare alla pagina del diario
  void _toDiaryPage(BuildContext context) async {

    SharedPreferences sp = await SharedPreferences.getInstance();

    //Se non ho mai scritto nel diario inizializzo la variabile che mi dice l'ultima data in cui ho scritto
    if(sp.containsKey('lastEntryDate') == false){
      //La gestisco in formato stringa perchè è meglio compatibile con altri metodi
      sp.setString('lastEntryDate', getTodayDate());
      sp.setBool('firstEntryOfToday', true);
      print("('lastEntryDate') == false");
      //Prepopolazione del database prima del primo ingresso in app
      await prepopulate(context);
      print('Populated');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Diary()));

    //Se oggi ho gia scritto non vado al diario
    } else if(sp.getString('lastEntryDate') == getTodayDate()){
      //Variabile potenzialmente inutile, basta non andare mai al diario
      //Potrebbe essere usata come sicurezza in più se l'utente accede in modo non intenzionale alla pagina
      sp.setBool('firstEntryOfToday', false); 
      print("Oggi ho gia scritto");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Homepage()));

    //Se oggi non ho gia scritto aggiorno la variabile e vado al diario
    } else{
      sp.setString('lastEntryDate', getTodayDate());
      //Variabile potenzialmente inutile, basta non andare mai al diario
      sp.setBool('firstEntryOfToday', true); 
      print('"Oggi non ho ancora scritto"');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Diary()));
    }    
  }
  
  } // LoginScreen