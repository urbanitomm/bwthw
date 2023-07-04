import 'package:provider/provider.dart';
import 'package:progetto_wearable/repository/providerHR.dart';
import 'package:progetto_wearable/database/entities/HRentity.dart';
import 'package:flutter/material.dart';

class prova extends StatefulWidget {
  const prova({Key? key}) : super(key: key);

  static const route = '/profile/';
  static const routeDisplayName = 'ProfilePage';

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

    // Fetch the HR entities from the database
    List<HREntity> hrEntities = await providerHR.findAllHR();

    // Print the fetched HR entities
    hrEntities.forEach((hrEntity) {
      print(
          'ID: ${hrEntity.id}, Date: ${hrEntity.date}, Time: ${hrEntity.time}, Value: ${hrEntity.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    // ...

    return Scaffold();
  }
}
