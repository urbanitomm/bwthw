import 'package:provider/provider.dart';
import 'package:progetto_wearable/repository/providerHR.dart';
import 'package:progetto_wearable/database/entities/HRentity.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/repository/providerSleep.dart';
import 'package:progetto_wearable/database/entities/sleepentry.dart';
import 'package:progetto_wearable/screens/homepage.dart';

class prova extends StatefulWidget {
  const prova({Key? key}) : super(key: key);

  static const route = '/prova/';
  static const routeDisplayName = 'provaPage';

  @override
  ProvaState createState() => ProvaState();
}

class ProvaState extends State<prova> {
  @override
  void initState() {
    super.initState();
    fetchHRData();
  }

  Future<void> fetchHRData() async {
    var providerHR = Provider.of<ProviderHR>(context, listen: false);
    var providerSleep = Provider.of<ProviderSleep>(context, listen: false);
    int? j = await providerHR.howManyHR();
    print(j);

    int? t = await providerSleep.howManySleep();
    // Fetch the HR entities from the database
    List<HREntity> hrEntities = await providerHR.findAllHR();
    List<Sleepentry> slentity = await providerSleep.findAllSleep();
    // Print the fetched HR entities
    hrEntities.forEach((hrEntity) {
      print(
          'ID: ${hrEntity.id}, Date: ${hrEntity.date}, Time: ${hrEntity.time}, Value: ${hrEntity.value}');
    });
    print('finished with HR');

    slentity.forEach((slEntity) {
      print(
          'Date: ${slEntity.date}, StartTime: ${slEntity.startTime}, EndTime: ${slEntity.endTime}, Efficiency: ${slEntity.duration}, Value: ${slEntity.efficiency}');
    });
    print('finished with HR');
  }

  @override
  Widget build(BuildContext context) {
    // ...

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
