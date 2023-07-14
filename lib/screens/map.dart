import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:progetto_wearable/repository/localizatioProvider.dart';
import 'package:progetto_wearable/screens/Options.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/notifi_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng currentLocation = LatLng(0.0, 0.0);
  final Geodesy geodesy = Geodesy();
  StreamSubscription<Position>? positionStream;
  late MapController _mapController;
  bool didFetchLocation = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!didFetchLocation) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        getCurrentLocation();
      });
      didFetchLocation = true;
    }
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> sendNotificationIfCurrentLocationMatchesLogo() async {
    bool isGeolocalizationEnabled =
        Provider.of<GeolocationProvider>(context, listen: false)
            .serviceEnabled1;
    LocationPermission permission =
        Provider.of<GeolocationProvider>(context, listen: false).permission1;
    if (isGeolocalizationEnabled && permission != LocationPermission.denied) {
      final num distance = geodesy.distanceBetweenTwoGeoPoints(
        //LatLng(45.560392, 11.535826),
        //currentLocation!,
        LatLng(45.408945, 11.894460), //dei position
        currentLocation!,
      );

      if (distance < 100) {
        NotificationService().showNotification(
          id: 3,
          title:
              'You are nearby a hotspot. If you need support, call an emergency number!',
        );
      }
    }
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();

    LocationData? locationData;

    bool isGeolocalizationEnabled =
        Provider.of<GeolocationProvider>(context, listen: false)
            .serviceEnabled1;
    LocationPermission permission =
        Provider.of<GeolocationProvider>(context, listen: false).permission1;

    if (!isGeolocalizationEnabled || permission != LocationPermission.always) {
      await location.enableBackgroundMode(enable: false);
      await NotificationService().cancelNotification();

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final snackBar = SnackBar(
          backgroundColor: Colors.deepOrange,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          content: Container(
            width: 250, // Adjust the width as desired
            height: 100, // Adjust the height as desired
            child: Center(
              child: Text(
                'You should activate geolocalization to access this page',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Options();
          }));
        });
      });
      /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.deepOrange,
        content:
            Text('You should activate geolocalization to access to this page'),
        duration: const Duration(seconds: 2),
      ));*/
      return;
    }

    await location.enableBackgroundMode(enable: true);
    locationData = await location.getLocation();

    setState(() {
      currentLocation =
          LatLng(locationData!.latitude ?? 0.0, locationData.longitude ?? 0.0);
    });
    _mapController.move(currentLocation, 18);

    positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      if (position != null) {
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(currentLocation, 18);
        sendNotificationIfCurrentLocationMatchesLogo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Homepage();
          }));
        },
        child: const Icon(Icons.arrow_back),
      ),
      body: Material(
        child: currentLocation != null
            ? FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: currentLocation,
                  zoom: 16,
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
                        point: currentLocation!,
                        width: 80,
                        height: 80,
                        builder: (context) => Icon(
                          Icons.circle,
                          color: Colors.yellow,
                          size: 40,
                        ),
                      ),
                      Marker(
                        point: LatLng(45.408945, 11.894460),
                        width: 80,
                        height: 80,
                        builder: (context) => Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      Marker(
                        point: LatLng(45.560392, 11.535826),
                        width: 80,
                        height: 80,
                        builder: (context) => Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
