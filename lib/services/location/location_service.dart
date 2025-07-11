import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();
  LocationService._();

  StreamController<Position>? _positionController;
  Stream<Position>? _positionStream;
  Position? _lastKnownPosition;

  Stream<Position> get positionStream {
    _positionStream ??= _createPositionStream();
    return _positionStream!;
  }

  Position? get lastKnownPosition => _lastKnownPosition;

  Future<bool> requestPermissions() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<bool> checkPermissions() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  Stream<Position> _createPositionStream() {
    _positionController = StreamController<Position>.broadcast();
    
    _startLocationTracking();
    
    return _positionController!.stream;
  }

  Future<void> _startLocationTracking() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        final granted = await requestPermissions();
        if (!granted) {
          throw Exception('Location permission denied');
        }
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      );

      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen(
        (Position position) {
          _lastKnownPosition = position;
          _positionController?.add(position);
        },
        onError: (error) {
          print('Location error: $error');
        },
      );

      // Get initial position
      final position = await getCurrentPosition();
      if (position != null) {
        _lastKnownPosition = position;
        _positionController?.add(position);
      }
    } catch (e) {
      print('Error starting location tracking: $e');
    }
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      _lastKnownPosition = position;
      return position;
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  void dispose() {
    _positionController?.close();
    _positionController = null;
    _positionStream = null;
  }
}

