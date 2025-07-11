import 'package:flutter/material.dart';
import '../models/bus/bus_stop.dart';
import '../models/route/bus_route.dart';
import '../services/data/bus_data_service.dart';

class BusProvider extends ChangeNotifier {
  List<BusStop> _nearbyStops = [];
  List<BusArrival> _arrivals = [];
  BusStop? _selectedStop;
  bool _isLoading = false;

  List<BusStop> get nearbyStops => _nearbyStops;
  List<BusArrival> get arrivals => _arrivals;
  BusStop? get selectedStop => _selectedStop;
  bool get isLoading => _isLoading;

  Future<void> loadNearbyStops(double latitude, double longitude) async {
    _isLoading = true;
    notifyListeners();

    try {
      _nearbyStops = await BusDataService.instance.getNearbyStops(latitude, longitude);
    } catch (e) {
      print('Error loading nearby stops: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadArrivals(String stopId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _arrivals = await BusDataService.instance.getArrivalsForStop(stopId);
    } catch (e) {
      print('Error loading arrivals: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectStop(BusStop stop) {
    _selectedStop = stop;
    notifyListeners();
    loadArrivals(stop.id);
  }
}

