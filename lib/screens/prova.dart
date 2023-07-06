import 'package:progetto_wearable/utils/funcs.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/repository/providerHR.dart';
import 'package:progetto_wearable/database/entities/HRentity.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/repository/providerSleep.dart';
import 'package:progetto_wearable/database/entities/sleepentry.dart';
import 'package:progetto_wearable/screens/homepage.dart';

class Prova extends StatefulWidget {
  const Prova({Key? key}) : super(key: key);

  static const route = '/prova/';
  static const routeDisplayName = 'provaPage';

  @override
  ProvaState createState() => ProvaState();
}

class ProvaState extends State<Prova> {
  List<double?> val = [];

  @override
  void initState() {
    super.initState();
    fetchHRData();
  }

  Future<void> fetchHRData() async {
    var providerHR = Provider.of<ProviderHR>(context, listen: false);
    var providerSleep = Provider.of<ProviderSleep>(context, listen: false);
    // Fetch the HR entities from the database
    String date = '2023-07-03';
    List<HREntity> hrEntities = await providerHR.findDateEntry(date);
    /*double? start_time = await providerSleep.findStartTime(date);
    double? end_time = await providerSleep.findEndTime(date);*/
    Sleepentry? sl = await providerSleep.findDateSleep(date);
    print(sl);

    // Print the fetched HR entities
    print('time of the first HR entry of the' + date);
    print(doubleToString(hrEntities.first.time));
    print(hrEntities.first.time);

    print('time of the last HR entry of the' + date);
    print(doubleToString(hrEntities.last.time));
    print(hrEntities.last.time);

    print('start time of the sleep of the' + date);
    print(sl?.startTime);
    print(doubleToString(sl?.startTime));

    print('end time of the sleep of the' + date);
    print(sl?.endTime);
    print(doubleToString(sl?.endTime));
  }

  //check if the user has drunk alcohol in the last 24 hours
  //if yes, return true
  //if no, return false
  Future<bool?> AlcolCheck(String date) async {
    DateTime dateTime = DateTime.parse(date);
    DateTime previousDay = dateTime.subtract(Duration(days: 1));

    String previousDate = previousDay.toString().substring(0, 10);
    Sleepentry? sleepentry_previous_day =
        await Provider.of<ProviderSleep>(context, listen: false)
            .findDateSleep(previousDate);
    if (sleepentry_previous_day == null ||
        sleepentry_previous_day.startTime == null ||
        sleepentry_previous_day.endTime == null) {
      return null;
    } else {
      List<int?> valuesHR1 = await Provider.of<ProviderHR>(context,
              listen: false)
          .findEntriesAfter(previousDate, sleepentry_previous_day.startTime!);
      List<int?> valuesHR2 =
          await Provider.of<ProviderHR>(context, listen: false)
              .findEntriesBefore(date, sleepentry_previous_day.endTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prova'),
      ),
      body: ListView.builder(
        itemCount: val.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Value: ${val[index]}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
