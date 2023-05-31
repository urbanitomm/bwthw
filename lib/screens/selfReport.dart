import 'package:flutter/material.dart';
import 'package:progetto_wearable/database/entities/report.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/repository/databaserepository.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:progetto_wearable/utils/funcs.dart';

class SelfReport extends StatefulWidget {
   const SelfReport({Key? key}) : super(key: key);

  static const route = '/selfreport/';
  static const routename = 'SelfReport';

  @override
  State<SelfReport> createState() => _SelfReportState();
}

class _SelfReportState extends State<SelfReport> {
  DateTime selectedDate = DateTime.now();

  String? reportDate;
  String? reportLocation;
  String? reportAmount;

  final snackBarDate = const SnackBar(
    content: Text('You should pick a date'),
  );
  final snackBarLocation = const SnackBar(
    content: Text('You should write the location'),
  );
  final snackBarAmount = const SnackBar(
    content: Text('You should write the amount'),
  );

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        reportDate = dateToString(picked);
        print(reportDate);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    print('Selfreport built');

    //One controller for each textfield
    var textController1 = TextEditingController();
    var textController2 = TextEditingController();
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Fill all fields",
              style: TextStyle(  
              fontSize: 22)),
              const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("When did you consume alcohol?",
              style: TextStyle(  
              fontSize: 16)
            ),
            Text("${selectedDate.toLocal()}".split(' ')[0]),
            const SizedBox(height: 20.0,),
            ElevatedButton(
              onPressed: () => selectDate(context),
              child: const Text('Select date'),
              ),
            
          
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 300.0,
              child:
                TextField(
                  controller: textController1,
                  maxLines: 4,
                  onChanged: (text) {  
                    reportLocation = text;  
                  },
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Where did you consume it?',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon:IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: (){
                      textController1.clear();
                      }),
                    ),
                  )),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 300.0,
              child:
                TextField(
                  controller: textController2,
                  maxLines: 4,
                  onChanged: (text) {  
                    reportAmount = text;  
                  },
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'How much alcohol did you consume?',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon:IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: (){
                      textController2.clear();
                      }),
                    ),
                  )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: (){
                  reportCheck(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                    child: const Text(
                      'Submit',
                      style: TextStyle(  
                        fontSize: 25)),  
                  ),
          ],
        ),
      ),
      
    );
  } //build

  void reportCheck(BuildContext context) async{
  
    if(reportDate == null) { //Snackbar for missing date
      ScaffoldMessenger.of(context).showSnackBar(snackBarDate);

    }else if(reportLocation == '' || reportLocation == null){ //Snackbar for missing location
      ScaffoldMessenger.of(context).showSnackBar(snackBarLocation);

    }else if(reportAmount == '' || reportAmount == null){ //Snackbar for missing amount
      ScaffoldMessenger.of(context).showSnackBar(snackBarAmount);

    }else{ //If everything is ok i record the report into the database
    final String reportContent = "Location: $reportLocation \n Amount: $reportAmount";
    print(reportDate);
    print(reportContent);
    //Guarda fine codice per vedere l'errore
      await Provider.of<DatabaseRepository>(context, listen: false)
                .insertReport(Report(reportDate!, reportContent));
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));

    }
  }
} //SelfReport

/*
E/flutter ( 3283):
E/flutter ( 3283):   consider using `builder` like so:
E/flutter ( 3283):
E/flutter ( 3283):   ```
E/flutter ( 3283):   Widget build(BuildContext context) {
E/flutter ( 3283):     return Provider<Example>(
E/flutter ( 3283):       create: (_) => Example(),
E/flutter ( 3283):       // we use `builder` to obtain a new `BuildContext` that has access to the provider
E/flutter ( 3283):       builder: (context, child) {
E/flutter ( 3283):         // No longer throws
E/flutter ( 3283):         return Text(context.watch<Example>().toString());
E/flutter ( 3283):       }
E/flutter ( 3283):     );
E/flutter ( 3283):   }
E/flutter ( 3283):   ```
E/flutter ( 3283):
E/flutter ( 3283): If none of these solutions work, consider asking for help on StackOverflow:
E/flutter ( 3283): https://stackoverflow.com/questions/tagged/flutter
*/