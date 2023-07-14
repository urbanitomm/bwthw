import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationProvider with ChangeNotifier {
  bool serviceEnabled1 = true;
  LocationPermission permission1 = LocationPermission.always;

  bool? get isEnabled => serviceEnabled1;
  LocationPermission? get permission => permission1;

  Future<void> enableGeolocalizatio(
      bool newServiceEnabled, LocationPermission newPermission) async {
    serviceEnabled1 = newServiceEnabled;
    permission1 = newPermission;
    notifyListeners();
  }

  Future<void> disableGeolocalizatio(
      bool newServiceEnabled, LocationPermission newPermission) async {
    serviceEnabled1 = newServiceEnabled;
    permission1 = newPermission;
    notifyListeners();
  }
}
