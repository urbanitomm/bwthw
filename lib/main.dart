import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/repository/databaseRepository.dart';
import 'package:progetto_wearable/repository/providerDataBaseSR.dart';
import 'package:progetto_wearable/repository/providerHR.dart';
import 'package:progetto_wearable/repository/providerSleep.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/screens/login.dart';
import 'package:progetto_wearable/utils/notifi_service.dart';
import 'package:progetto_wearable/repository/localizatioProvider.dart';

Future<void> main() async {
  //This is a special method that use WidgetFlutterBinding to interact with the Flutter engine.
  //This is needed when you need to interact with the native core of the app.
  //Here, we need it since when need to initialize the DB before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  //This opens the database.
  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);

  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  //Here, we run the app and we provide to the whole widget tree the instance of the DatabaseRepository.
  //That instance will be then shared through the platform and will be unique.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseRepository>.value(
          value: databaseRepository,
        ),
        ChangeNotifierProvider<SelfReportProvider>(
          create: (_) => SelfReportProvider(database: database),
        ),
        ChangeNotifierProvider<ProviderHR>(
          create: (_) => ProviderHR(database: database),
        ),
        ChangeNotifierProvider<ProviderSleep>(
          create: (_) => ProviderSleep(database: database),
        ),
        ChangeNotifierProvider<GeolocationProvider>(
          create: (_) => GeolocationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  } //build
} //MyApp
