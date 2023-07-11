import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geodesy/geodesy.dart';
import 'package:progetto_wearable/utils/notifi_service.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? currentLocation; // Nullable type
  final Geodesy geodesy = Geodesy();
  Future<void> sendNotificationIfCurrentLocationMatchesLogo() async {
    if (currentLocation != null) {
      //Calculate the distance in meters between two geo points. If radius is not specified, Earth radius will be used.
      final num distance = geodesy.distanceBetweenTwoGeoPoints(
        LatLng(45.560392, 11.535826),
        //currentLocation!,
        //LatLng(45.408945, 11.894460), //dei position
        currentLocation!,
      );

      if (distance < 50) {
        NotificationService().showNotification(
            title:
                'You are nearby a hotspot. If you need support, call an emergency number!');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await AppSettings.openAppSettings(type: AppSettingsType.location);

      // Open app settings
      // Location permission will be checked again after returning from app settings
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle scenario when user denied permission forever
      return;
    }
    //await AppSettings.openAppSettings(type: AppSettingsType.notification);
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
    await sendNotificationIfCurrentLocationMatchesLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //sendNotificationIfCurrentLocationMatchesLogo();
          //NotificationService().showNotification(title: 'You are here!');
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
      body: Material(
        child: currentLocation != null
            ? FlutterMap(
                options: MapOptions(
                  center: currentLocation!,
                  zoom: 18,
                ),
                nonRotatedChildren: [
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright'),
                        ),
                      ),
                    ],
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(51.509364, -0.128928),
                        width: 80,
                        height: 80,
                        builder: (context) => FlutterLogo(),
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(), // or any loading indicator
              ),
      ),
    );
  }
}

/*class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? currentLocation; // Nullable type

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await AppSettings.openAppSettings(type: AppSettingsType.location);
      // Open app settings
      // Location permission will be checked again after returning from app settings
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle scenario when user denied permission forever
      return;
    }
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: currentLocation != null
            ? FlutterMap(
                options: MapOptions(
                  center: currentLocation!,
                  zoom: 18,
                ),
                nonRotatedChildren: [
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright'),
                        ),
                      ),
                    ],
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(51.509364, -0.128928),
                        width: 80,
                        height: 80,
                        builder: (context) => FlutterLogo(),
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(), // or any loading indicator
              ),
      ),
    );
  }
}*/
