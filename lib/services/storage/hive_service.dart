import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/bus/bus_stop.dart';

import '../../models/route/bus_route.dart';
import '../../models/user/user_preferences.dart';

class HiveService {
  // Box names as constants to avoid getter conflicts
  static const String busStopsBoxName = 'bus_stops';
  static const String busRoutesBoxName = 'bus_routes';
  static const String busArrivalsBoxName = 'bus_arrivals';
  static const String userPreferencesBoxName = 'user_preferences';
  static const String favoritesBoxName = 'favorites';

  static Future<void> init() async {
    // Register adapters (typeId must match your models)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BusStopAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BusRouteAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(BusArrivalAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserPreferencesAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(FavoriteItemAdapter());
    }

    // Open boxes
    await Future.wait([
      Hive.openBox<BusStop>(busStopsBoxName),
      Hive.openBox<BusRoute>(busRoutesBoxName),
      Hive.openBox<BusArrival>(busArrivalsBoxName),
      Hive.openBox<UserPreferences>(userPreferencesBoxName),
      Hive.openBox<FavoriteItem>(favoritesBoxName),
    ]);

    // Initialize default data if needed
    await _initializeDefaultData();
  }

  static Future<void> _initializeDefaultData() async {
    final preferencesBox = Hive.box<UserPreferences>(userPreferencesBoxName);

    // Create default user preferences if none exist
    if (preferencesBox.isEmpty) {
      final defaultPrefs = UserPreferences.defaultPreferences();
      await preferencesBox.put('default', defaultPrefs);
    }

    // Add sample bus stops and routes for demo
    await _addSampleData();
  }

  static Future<void> _addSampleData() async {
    final stopsBox = Hive.box<BusStop>(busStopsBoxName);
    final routesBox = Hive.box<BusRoute>(busRoutesBoxName);

    if (stopsBox.isEmpty) {
      // Sample bus stops
      final sampleStops = [
        BusStop(
          id: 'stop_001',
          name: 'Central Station',
          code: 'CS001',
          latitude: 37.7749,
          longitude: -122.4194,
          description: 'Main transit hub',
          routeIds: ['route_001', 'route_002'],
        ),
        BusStop(
          id: 'stop_002',
          name: 'University Campus',
          code: 'UC002',
          latitude: 37.7849,
          longitude: -122.4094,
          description: 'University main entrance',
          routeIds: ['route_001'],
        ),
        BusStop(
          id: 'stop_003',
          name: 'Shopping Mall',
          code: 'SM003',
          latitude: 37.7649,
          longitude: -122.4294,
          description: 'Main shopping center',
          routeIds: ['route_002'],
        ),
        BusStop(
          id: 'stop_004',
          name: 'Hospital',
          code: 'HP004',
          latitude: 37.7549,
          longitude: -122.4394,
          description: 'City general hospital',
          routeIds: ['route_001', 'route_002'],
        ),
      ];

      for (final stop in sampleStops) {
        await stopsBox.put(stop.id, stop);
      }
    }

    if (routesBox.isEmpty) {
      // Sample bus routes
      final sampleRoutes = [
        BusRoute(
          id: 'route_001',
          routeNumber: '101',
          routeName: 'Downtown Express',
          origin: 'Central Station',
          destination: 'University Campus',
          stopIds: ['stop_001', 'stop_002', 'stop_004'],
          color: '#FF5722',
          estimatedDuration: 25,
          description: 'Express service to university',
        ),
        BusRoute(
          id: 'route_002',
          routeNumber: '202',
          routeName: 'City Circle',
          origin: 'Central Station',
          destination: 'Shopping Mall',
          stopIds: ['stop_001', 'stop_003', 'stop_004'],
          color: '#2196F3',
          estimatedDuration: 35,
          description: 'Circular route around city center',
        ),
      ];

      for (final route in sampleRoutes) {
        await routesBox.put(route.id, route);
      }
    }
  }

  // Bus Stops operations
  static Box<BusStop> get busStopsBox => Hive.box<BusStop>(busStopsBoxName);

  static Future<void> saveBusStop(BusStop stop) async {
    await busStopsBox.put(stop.id, stop);
  }

  static BusStop? getBusStop(String id) {
    return busStopsBox.get(id);
  }

  static List<BusStop> getAllBusStops() {
    return busStopsBox.values.toList();
  }

  static Future<void> deleteBusStop(String id) async {
    await busStopsBox.delete(id);
  }

  // Bus Routes operations
  static Box<BusRoute> get busRoutesBox => Hive.box<BusRoute>(busRoutesBoxName);

  static Future<void> saveBusRoute(BusRoute route) async {
    await busRoutesBox.put(route.id, route);
  }

  static BusRoute? getBusRoute(String id) {
    return busRoutesBox.get(id);
  }

  static List<BusRoute> getAllBusRoutes() {
    return busRoutesBox.values.toList();
  }

  // Bus Arrivals operations
  static Box<BusArrival> get busArrivalsBox =>
      Hive.box<BusArrival>(busArrivalsBoxName);

  static Future<void> saveBusArrival(BusArrival arrival) async {
    await busArrivalsBox.put(arrival.id, arrival);
  }

  static List<BusArrival> getBusArrivalsForStop(String stopId) {
    return busArrivalsBox.values
        .where((arrival) => arrival.stopId == stopId)
        .toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  // User Preferences operations
  static Box<UserPreferences> get userPreferencesBox =>
      Hive.box<UserPreferences>(userPreferencesBoxName);

  static Future<void> saveUserPreferences(UserPreferences preferences) async {
    await userPreferencesBox.put('default', preferences);
  }

  static UserPreferences getUserPreferences() {
    return userPreferencesBox.get('default') ??
        UserPreferences.defaultPreferences();
  }

  // Favorites operations
  static Box<FavoriteItem> get favoritesBox =>
      Hive.box<FavoriteItem>(favoritesBoxName);

  static Future<void> saveFavorite(FavoriteItem favorite) async {
    await favoritesBox.put(favorite.id, favorite);
  }

  static Future<void> deleteFavorite(String id) async {
    await favoritesBox.delete(id);
  }

  static List<FavoriteItem> getAllFavorites() {
    return favoritesBox.values.toList()
      ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  }

  static List<FavoriteItem> getFavoritesByType(String type) {
    return favoritesBox.values
        .where((favorite) => favorite.type == type)
        .toList()
      ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  }

  // Cleanup operations
  static Future<void> clearAllData() async {
    await Future.wait([
      busStopsBox.clear(),
      busRoutesBox.clear(),
      busArrivalsBox.clear(),
      favoritesBox.clear(),
    ]);
  }

  static Future<void> clearOldArrivals() async {
    final now = DateTime.now();
    final oldArrivals = busArrivalsBox.values
        .where((arrival) => arrival.scheduledTime
            .isBefore(now.subtract(const Duration(hours: 2))))
        .toList();

    for (final arrival in oldArrivals) {
      await busArrivalsBox.delete(arrival.id);
    }
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
