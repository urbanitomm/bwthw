import 'dart:async';

import 'package:progetto_wearable/database/entities/diaryentry.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/repository/databaseRepository.dart';
import 'package:progetto_wearable/repository/providerDataBaseSR.dart';
import 'package:progetto_wearable/database/entities/report.dart';

//
//      TO DO:
//    Appena possibile sostituire le variabili sostiche happypressed, neutralpressed, sadpressed con
//    delle variabili provenienti dalle shared preferences di modo da poter lavorare con dati aggiornati
//
//
//

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomAgenda(),
    );
  }
}

class CustomAgenda extends StatefulWidget {
  const CustomAgenda({super.key});

  @override
  State<StatefulWidget> createState() => CalendarDiary();
}

class CalendarDiary extends State<CustomAgenda> {
  final List<Appointment> _appointmentDetails = <Appointment>[];

  //DataSource is the proprietary data format for the SfCalendar widget
  late Future<DataSource> dataSourceFuture;
  late DataSource dataSource;

  @override
  void initState() {
    //Get the data from the database using a future
    dataSourceFuture = getCalendarDataSource();
    super.initState();
    //Convert from future to regular DataSource
    deFuture(dataSourceFuture).then((dataSourceFuture) {
      dataSource = dataSourceFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(body: SafeArea(child: Consumer<DatabaseRepository>(
      builder: (context, dbr, child) {
        //Fetching the data from the database
        return FutureBuilder(
            initialData: null,
            future: dbr.findAllEntries(),
            builder: (context, snapshot) {
              //Converting it into the Datasource format
              return FutureBuilder(
                  initialData: null,
                  future: getCalendarDataSource(),
                  builder: (context, dataSourcesnapshot) {
                    if (dataSourcesnapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: SfCalendar(
                              view: CalendarView.month,
                              dataSource: dataSource,
                              initialSelectedDate: DateTime
                                  .now(), //The first selected day is today
                              onSelectionChanged: selectionChanged,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  color: Colors.black12,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(2),
                                    itemCount: _appointmentDetails.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SingleChildScrollView(
                                          child: Container(
                                              constraints: const BoxConstraints(
                                                maxWidth: 250,
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              color: _appointmentDetails[index]
                                                  .color,
                                              child: ListTile(
                                                leading: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        child: Icon(
                                                      getIcon(
                                                          _appointmentDetails[
                                                                  index]
                                                              .color),
                                                      size: 30,
                                                      color: Colors.white,
                                                    )),
                                                  ],
                                                ),
                                                title: Container(
                                                    child: Text(
                                                        _appointmentDetails[
                                                                index]
                                                            .subject,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white))),
                                              )));
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(
                                      height: 5,
                                    ),
                                  ))),
                        ],
                      );
                    } else {
                      //A CircularProgressIndicator is shown while is loading.
                      return const Center(child: CircularProgressIndicator());
                    }
                  } //else
                  );
            } //builder of second FutureBuilder
            );
      }, //builder of first FutureBuilder
    ))));
  }

  //Highlight the selected date
  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
  }

  //Workaround for the conversion from Future<DataSource> to DataSource
  Future<DataSource> deFuture(Future<DataSource> dataSourceFuture) {
    return dataSourceFuture;
  }

  //Gets the appointments (diary entries) of a given date
  void getSelectedDateAppointments(DateTime? selectedDate) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _appointmentDetails.clear();
      });

      if (dataSource.appointments!.isEmpty) {
        return;
      }

      for (int i = 0; i < dataSource.appointments!.length; i++) {
        Appointment appointment = dataSource.appointments![i] as Appointment;

        /// It return the occurrence appointment for the given pattern appointment at the selected date.
        final Appointment? occurrenceAppointment =
            dataSource.getOccurrenceAppointment(appointment, selectedDate!, '');
        if ((DateTime(appointment.startTime.year, appointment.startTime.month,
                    appointment.startTime.day) ==
                DateTime(
                    selectedDate.year, selectedDate.month, selectedDate.day)) ||
            occurrenceAppointment != null) {
          setState(() {
            _appointmentDetails.add(appointment);
          });
        }
      }
    });
  }

  Future<DataSource> getCalendarDataSource() async {
    final List<Appointment> appointments = <Appointment>[];

    int? dbLen = await Provider.of<DatabaseRepository>(context, listen: false)
        .howManyEntries();
    if (dbLen == null) {
      print('NON DOVREBBE ESSERE POSSIBILE AVERE NULL ENTRY NEL DB');
      dbLen = 0;
    }

    List<Diaryentry> db =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findAllEntries();
    List<Report> reports =
        await Provider.of<SelfReportProvider>(context, listen: false)
            .findAllReports();

    for (var i = 0; i < dbLen; i++) {
      Diaryentry consideredEntry = db[i];

      appointments.add(Appointment(
        startTime: DateTime.parse(consideredEntry.date),
        endTime: DateTime.parse(consideredEntry.date)
            .add(const Duration(hours: 5, days: -1)),
        subject: consideredEntry.entry,
        color: getColor(consideredEntry.mood),
        isAllDay: true,
      ));
    }

    for (var report in reports) {
      appointments.add(Appointment(
        startTime: DateTime.parse(report.date),
        endTime:
            DateTime.parse(report.date).add(const Duration(hours: 5, days: -1)),
        subject: report.content,
        color: Color.fromARGB(255, 76, 147, 175),
        isAllDay: true,
      ));
    }

    return DataSource(appointments);
  }

  //Color comparison
  bool compare(Color color1, Color color2) {
    return color1.value == color2.value;
  }

  //Function that gets the icons from the mood of the entry
  IconData getIcon(Color mood) {
    if (compare(mood, Colors.green)) {
      return Icons.sentiment_very_satisfied;
    } else if (compare(mood, Colors.orange)) {
      return Icons.sentiment_neutral;
    } else if (compare(mood, Colors.red)) {
      return Icons.sentiment_very_dissatisfied;
    } else {
      print('Qualcosa è andato storto nella selezione del mood');
      return Icons.question_mark;
    }
  }

  //Function that gets the color from the mood of the entry
  getColor(mood) {
    if (mood == 'Happy') {
      return Colors.green;
    } else if (mood == 'Neutral') {
      return Colors.orange;
    } else if (mood == 'Sad') {
      return Colors.red;
    } else {
      print('Qualcosa è andato storto nella selezione del colore');
      return Colors.black;
    }
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

//BLOCCHI DI CODICE POTENZIALMENTE UTILI

//String entry;
//Future <String> futureEntry = getEntry();

/*getEntry().then((entries) {
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: entries[1],
      color: Colors.orange,
    ));
  });*/

/*
class EntryDataSource extends CalendarDataSource {
  EntryDataSource(List<DiaryEntry> source) {
    var appointments = source;
  }

  @override
  DateTime getEntryTime(int index) {
    return appointments![index].entryTime;
  }

  @override
  DateTime getEntryContent(int index) {
    return appointments![index].entryContent;
  }

  @override
  String getEntryMood(int index) {
    return appointments![index].entryMood;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}


class DiaryEntry {
  DiaryEntry(this.entryContent, this.entryMood, this.background);

  String entryContent;
  String entryMood;
  DateTime entryTime = DateTime.now();
  Color background;
  bool isAllDay = true;
}


List<DiaryEntry> _getDataSource() {
  final List<DiaryEntry> appointments = <DiaryEntry>[];
  final DateTime today = DateTime.now();
  final DateTime entryTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  appointments.add(DiaryEntry(
      'Diary entry', 'Happy', const Color(0xFF0F8644)));
  return appointments;
}
*/

/*
  DataSource getCalendarDataBase() {
    final List<Appointment> appointments = <Appointment>[];

    appointments.add(Appointment(
        startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
        endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
        //testo test
        subject: ' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec at egestas nulla, ut volutpat urna. Ut et urna sit amet sapien dictum porta sit amet vel mi. Duis quam augue, ultricies at erat et, tincidunt vehicula elit. Mauris elit mauris, vestibulum sit amet magna a, rhoncus volutpat lectus. Nullam urna erat, molestie sit amet massa in, congue imperdiet dolor. In mattis sed diam vitae tempus. Donec blandit, lorem sed ultricies viverra, mauris enim venenatis eros, ac rutrum sem libero eu est. Nulla ultricies at turpis vel pellentesque. Etiam lacinia ultricies tortor porta hendrerit. Phasellus varius neque lorem, vitae suscipit turpis imperdiet vitae. Curabitur vitae ipsum quis erat efficitur porta at vel dui. Aliquam cursus, nunc non consectetur luctus, risus elit sollicitudin sapien, vel iaculis nulla felis vitae mi. Nulla fringilla augue lacinia ultricies vehicula. Ut sem odio, convallis eu rhoncus viverra, finibus id neque. Nulla molestie turpis eu diam dictum aliquam sed a massa. Quisque sed consectetur mi. Vestibulum id lacinia quam. Ut iaculis, massa ut dignissim dignissim, nunc odio fringilla leo, sed varius massa elit vitae metus. Aenean quis sapien et nunc malesuada suscipit sed rhoncus enim. Maecenas in suscipit risus, vestibulum malesuada libero. Duis turpis justo, suscipit vel rhoncus quis, accumsan id nisl. Sed vestibulum, nisi quis consectetur sodales, nunc justo auctor nisi, non fermentum augue tellus et purus. Ut ut semper elit. Sed et ipsum aliquam, luctus lorem a, accumsan erat. Sed tincidunt nisl sit amet libero congue sagittis. ',
        color: Colors.green,
        // Appena saranno attivate le shared preferences usare getColor(),
        isAllDay: true));


    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 5)),
      subject: 'Sad',
      color: Colors.red,
        // Appena saranno attivate le shared preferences usare getColor(),
    ));
    return DataSource(appointments);
  }
  */

/*
  //Passo alla funzione che crea la lista di 'appuntamenti' la coppia test+colore di modo da
  //poter creare la entry in maniera corretta
  Future<String> getEntry()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  final String retrievedText = sp.getString(sp.getString('lastEntryDate')!)!;
  print('retrievedText');
  final String retrievedMood = sp.getString(sp.getString('lastEntryDate')!+'M')!;
  print('retrievedMood');
  final Color retrievedColor = getColor(retrievedMood);
  //final List entries = [retrievedText,retrievedColor];
  return retrievedText;
  } */

/*
    appointments.add(Appointment(
        startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
        endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
        //testo test
        subject: ' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec at egestas nulla, ut volutpat urna. Ut et urna sit amet sapien dictum porta sit amet vel mi. Duis quam augue, ultricies at erat et, tincidunt vehicula elit. Mauris elit mauris, vestibulum sit amet magna a, rhoncus volutpat lectus. Nullam urna erat, molestie sit amet massa in, congue imperdiet dolor. In mattis sed diam vitae tempus. Donec blandit, lorem sed ultricies viverra, mauris enim venenatis eros, ac rutrum sem libero eu est. Nulla ultricies at turpis vel pellentesque. Etiam lacinia ultricies tortor porta hendrerit. Phasellus varius neque lorem, vitae suscipit turpis imperdiet vitae. Curabitur vitae ipsum quis erat efficitur porta at vel dui. Aliquam cursus, nunc non consectetur luctus, risus elit sollicitudin sapien, vel iaculis nulla felis vitae mi. Nulla fringilla augue lacinia ultricies vehicula. Ut sem odio, convallis eu rhoncus viverra, finibus id neque. Nulla molestie turpis eu diam dictum aliquam sed a massa. Quisque sed consectetur mi. Vestibulum id lacinia quam. Ut iaculis, massa ut dignissim dignissim, nunc odio fringilla leo, sed varius massa elit vitae metus. Aenean quis sapien et nunc malesuada suscipit sed rhoncus enim. Maecenas in suscipit risus, vestibulum malesuada libero. Duis turpis justo, suscipit vel rhoncus quis, accumsan id nisl. Sed vestibulum, nisi quis consectetur sodales, nunc justo auctor nisi, non fermentum augue tellus et purus. Ut ut semper elit. Sed et ipsum aliquam, luctus lorem a, accumsan erat. Sed tincidunt nisl sit amet libero congue sagittis. ',
        color: Colors.green,
        // Appena saranno attivate le shared preferences usare getColor(),
        isAllDay: true));
        */

//String entry;
//Future <String> futureEntry = getEntry();

//The logic is to query the DB for the entire list of Todo using dbr.findAllTodos()
//and then populate the ListView accordingly.
//We need to use a FutureBuilder since the result of dbr.findAllTodos() is a Future.

//PROBLEMA: il futurebuilder viene chiamato prima della conclusione della inizializzazione di datasource
//dato che datasource richiede dei dati ottenuti in maniera asincrona ma l'attribuzione stessa non è asincrona
//questo fa chiamare il futurebuilder un istante prima del momento opportuno impedendo il caricamento corretto della pagina
