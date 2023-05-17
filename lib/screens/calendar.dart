import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/data.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/screens/diary.dart';
import 'package:progetto_wearable/screens/login.dart';


class Calendar extends StatelessWidget {
   Calendar({Key? key}) : super(key: key);

  static const routename = 'Calendar';

    @override
  Widget build(BuildContext context) {
    print('Calendar built');
    return Scaffold(
      /* Lascio qui l'app bar nel caso torni utile copiarla
      appBar: AppBar(
        title: Text('App Name'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Go back to the homepage',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ), 
      */
        body: Container(
      child: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: MonthViewSettings(
          showAgenda: true,
          agendaViewHeight: 300,
          ),

      ),
      
    ));
}



}
