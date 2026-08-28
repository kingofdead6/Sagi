import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum LocationOutcome { granted, denied, deniedForever, serviceDisabled, failed }

class LocationResult {
  const LocationResult(this.outcome, [this.position]);

  final LocationOutcome outcome;
  final LatLng? position;

  bool get isGranted => outcome == LocationOutcome.granted && position != null;
}

/// Wraps geolocator so screens never touch the plugin directly — and so every
/// denial path has an explicit outcome the UI can explain in Arabic.
class LocationService {
  /// Bir El Ater, the launch area — used when the device gives us nothing.
  static const fallbackCenter = LatLng(34.7442, 8.0603);

  Future<LocationResult> current({bool requestIfDenied = true}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationResult(LocationOutcome.serviceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && requestIfDenied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(LocationOutcome.deniedForever);
      }
      if (permission == LocationPermission.denied) {
        return const LocationResult(LocationOutcome.denied);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return LocationResult(
        LocationOutcome.granted,
        LatLng(position.latitude, position.longitude),
      );
    } catch (_) {
      return const LocationResult(LocationOutcome.failed);
    }
  }

  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> openSettings() => Geolocator.openLocationSettings();

  static double distanceMeters(LatLng a, LatLng b) =>
      Geolocator.distanceBetween(a.latitude, a.longitude, b.latitude, b.longitude);
}
