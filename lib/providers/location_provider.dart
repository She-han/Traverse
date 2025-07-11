import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location/location_service.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  bool _isTracking = false;
  String? _errorMessage;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  String? get errorMessage => _errorMessage;

  Future<void> startTracking() async {
    try {
      _isTracking = true;
      _errorMessage = null;
      notifyListeners();

      LocationService.instance.positionStream.listen(
        (position) {
          _currentPosition = position;
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = error.toString();
          _isTracking = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      _isTracking = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final position = await LocationService.instance.getCurrentPosition();
      if (position != null) {
        _currentPosition = position;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void stopTracking() {
    _isTracking = false;
    notifyListeners();
  }
}

