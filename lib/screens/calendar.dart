import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


//
//      TO DO:
//    Appena possibile sostituire le variabili sostiche happypressed, neutralpressed, sadpressed con 
//    delle variabili provenienti dalle shared preferences di modo da poter lavorare con dati aggiornati
//
//
//


class Calendar extends StatelessWidget {
  Calendar({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomAgenda(),
    );
  }
}
//TODO: ricordarsi di toglierle
bool _happyPressed = true;
bool _neutralPressed = false;
bool _sadPressed = false;

class CustomAgenda extends StatefulWidget {
  const CustomAgenda({super.key});

  @override
  State<StatefulWidget> createState() => ScheduleExample();
}


class ScheduleExample extends State<CustomAgenda> {
  final List<Appointment> _appointmentDetails = <Appointment>[];

  late _DataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = getCalendarDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: dataSource,
                initialSelectedDate: DateTime.now().add(const Duration(days: -1)),
                onSelectionChanged: selectionChanged,
              ),
            ),
            Expanded(
                child: Container(
                    color: Colors.black12,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(2),
                      itemCount: _appointmentDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          child: Container(
                            constraints: const BoxConstraints(
                            maxWidth: 250,
                            ),
                            padding: const EdgeInsets.all(2),
                            //height: 2000,
                            color: _appointmentDetails[index].color,
                            child: ListTile(
                              leading: Column(
                                children: <Widget>[
                                  Container(
                                  child: Icon(
                                    getIcon(_appointmentDetails[index].subject),
                                    size: 30,
                                    color: Colors.white,
                                  )),
                                ],
                              ),
                              title: Container(
                                  child: Text(
                                      '${_appointmentDetails[index].subject}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            )));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        height: 5,
                      ),
                    ))),
          ],
        ),
      ),
    ));
  }

  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
  }

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
        final Appointment? occurrenceAppointment = dataSource.getOccurrenceAppointment(appointment, selectedDate!, '');
        if ((DateTime(appointment.startTime.year, appointment.startTime.month,
            appointment.startTime.day) == DateTime(selectedDate.year,selectedDate.month,
            selectedDate.day)) || occurrenceAppointment != null) {
          setState(() {
            _appointmentDetails.add(appointment);
          });
        }
      }
    });
  }

  _DataSource getCalendarDataSource() {
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
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Neutral',
      color: Colors.orange,
      // Appena saranno attivate le shared preferences usare getColor(),
    ));

    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 5)),
      subject: 'Sad',
      color: Colors.red,
        // Appena saranno attivate le shared preferences usare getColor(),
    ));
    return _DataSource(appointments);
  }

  

  IconData getIcon(String subject) {
    if (subject == ' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec at egestas nulla, ut volutpat urna. Ut et urna sit amet sapien dictum porta sit amet vel mi. Duis quam augue, ultricies at erat et, tincidunt vehicula elit. Mauris elit mauris, vestibulum sit amet magna a, rhoncus volutpat lectus. Nullam urna erat, molestie sit amet massa in, congue imperdiet dolor. In mattis sed diam vitae tempus. Donec blandit, lorem sed ultricies viverra, mauris enim venenatis eros, ac rutrum sem libero eu est. Nulla ultricies at turpis vel pellentesque. Etiam lacinia ultricies tortor porta hendrerit. Phasellus varius neque lorem, vitae suscipit turpis imperdiet vitae. Curabitur vitae ipsum quis erat efficitur porta at vel dui. Aliquam cursus, nunc non consectetur luctus, risus elit sollicitudin sapien, vel iaculis nulla felis vitae mi. Nulla fringilla augue lacinia ultricies vehicula. Ut sem odio, convallis eu rhoncus viverra, finibus id neque. Nulla molestie turpis eu diam dictum aliquam sed a massa. Quisque sed consectetur mi. Vestibulum id lacinia quam. Ut iaculis, massa ut dignissim dignissim, nunc odio fringilla leo, sed varius massa elit vitae metus. Aenean quis sapien et nunc malesuada suscipit sed rhoncus enim. Maecenas in suscipit risus, vestibulum malesuada libero. Duis turpis justo, suscipit vel rhoncus quis, accumsan id nisl. Sed vestibulum, nisi quis consectetur sodales, nunc justo auctor nisi, non fermentum augue tellus et purus. Ut ut semper elit. Sed et ipsum aliquam, luctus lorem a, accumsan erat. Sed tincidunt nisl sit amet libero congue sagittis. ') {
      return Icons.sentiment_very_satisfied;
    } else if (subject == 'Neutral') {
      return Icons.sentiment_neutral;
    } else if (subject == 'Sad') {
      return Icons.sentiment_very_dissatisfied;
    } else {
      return Icons.sentiment_very_satisfied;
    }
  }

  getColor() {
    if (_happyPressed) {
      return Colors.green;
    } else if (_neutralPressed) {
      return Colors.orange;
    } else if (_sadPressed) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}







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