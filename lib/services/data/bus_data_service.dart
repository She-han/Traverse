import 'dart:async';
import 'dart:math';
import '../../models/bus/bus_stop.dart';
import '../../models/route/bus_route.dart';
import '../storage/hive_service.dart';

class BusDataService {
  static BusDataService? _instance;
  static BusDataService get instance => _instance ??= BusDataService._();
  BusDataService._();

  final Random _random = Random();

  Future<List<BusStop>> getNearbyStops(double latitude, double longitude, {double radiusKm = 2.0}) async {
    final allStops = HiveService.getAllBusStops();
    
    return allStops.where((stop) {
      final distance = stop.distanceTo(latitude, longitude);
      return distance <= radiusKm * 1000; // Convert km to meters
    }).toList()
      ..sort((a, b) {
        final distanceA = a.distanceTo(latitude, longitude);
        final distanceB = b.distanceTo(latitude, longitude);
        return distanceA.compareTo(distanceB);
      });
  }

  Future<List<BusArrival>> getArrivalsForStop(String stopId) async {
    // Simulate real-time arrivals
    final routes = HiveService.getAllBusRoutes()
        .where((route) => route.stopIds.contains(stopId))
        .toList();

    final arrivals = <BusArrival>[];
    final now = DateTime.now();

    for (final route in routes) {
      // Generate 3-5 upcoming arrivals for each route
      final arrivalCount = 3 + _random.nextInt(3);
      
      for (int i = 0; i < arrivalCount; i++) {
        final baseMinutes = 5 + (i * 15) + _random.nextInt(10);
        final scheduledTime = now.add(Duration(minutes: baseMinutes));
        
        // Add some random delay/early arrival
        final delayMinutes = _random.nextInt(11) - 5; // -5 to +5 minutes
        final estimatedTime = scheduledTime.add(Duration(minutes: delayMinutes));
        
        String status = 'on_time';
        if (delayMinutes > 2) {
          status = 'delayed';
        } else if (delayMinutes < -2) {
          status = 'early';
        }

        final arrival = BusArrival(
          id: '${route.id}_${stopId}_${i}_${now.millisecondsSinceEpoch}',
          routeId: route.id,
          stopId: stopId,
          scheduledTime: scheduledTime,
          estimatedTime: estimatedTime,
          status: status,
          delayMinutes: delayMinutes.abs() > 1 ? delayMinutes : null,
          isRealTime: _random.nextBool(),
        );

        arrivals.add(arrival);
      }
    }

    // Sort by arrival time
    arrivals.sort((a, b) => a.effectiveTime.compareTo(b.effectiveTime));
    
    // Save to local storage
    for (final arrival in arrivals) {
      await HiveService.saveBusArrival(arrival);
    }

    return arrivals;
  }

  Future<List<BusRoute>> getRoutesForStop(String stopId) async {
    final allRoutes = HiveService.getAllBusRoutes();
    return allRoutes.where((route) => route.stopIds.contains(stopId)).toList();
  }

  Future<List<BusRoute>> searchRoutes(String query) async {
    final allRoutes = HiveService.getAllBusRoutes();
    final lowerQuery = query.toLowerCase();
    
    return allRoutes.where((route) {
      return route.routeNumber.toLowerCase().contains(lowerQuery) ||
             route.routeName.toLowerCase().contains(lowerQuery) ||
             route.origin.toLowerCase().contains(lowerQuery) ||
             route.destination.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<List<BusStop>> searchStops(String query) async {
    final allStops = HiveService.getAllBusStops();
    final lowerQuery = query.toLowerCase();
    
    return allStops.where((stop) {
      return stop.name.toLowerCase().contains(lowerQuery) ||
             stop.code.toLowerCase().contains(lowerQuery) ||
             (stop.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Future<List<RouteSegment>> planRoute(String originStopId, String destinationStopId) async {
    // Simple route planning - in a real app, this would use a proper routing algorithm
    final allRoutes = HiveService.getAllBusRoutes();
    final allStops = HiveService.getAllBusStops();
    
    // Find direct routes
    final directRoutes = allRoutes.where((route) {
      final originIndex = route.stopIds.indexOf(originStopId);
      final destIndex = route.stopIds.indexOf(destinationStopId);
      return originIndex != -1 && destIndex != -1 && originIndex < destIndex;
    }).toList();

    if (directRoutes.isNotEmpty) {
      // Return direct route
      final route = directRoutes.first;
      final originIndex = route.stopIds.indexOf(originStopId);
      final destIndex = route.stopIds.indexOf(destinationStopId);
      
      return [
        RouteSegment(
          type: 'bus',
          routeId: route.id,
          routeNumber: route.routeNumber,
          fromStopId: originStopId,
          toStopId: destinationStopId,
          stopIds: route.stopIds.sublist(originIndex, destIndex + 1),
          estimatedDuration: ((destIndex - originIndex) * 3), // 3 minutes per stop
          instructions: 'Take bus ${route.routeNumber} from ${allStops.firstWhere((s) => s.id == originStopId).name} to ${allStops.firstWhere((s) => s.id == destinationStopId).name}',
        ),
      ];
    }

    // Find routes with one transfer
    for (final route1 in allRoutes) {
      if (!route1.stopIds.contains(originStopId)) continue;
      
      for (final route2 in allRoutes) {
        if (route1.id == route2.id) continue;
        if (!route2.stopIds.contains(destinationStopId)) continue;
        
        // Find common stops
        final commonStops = route1.stopIds.where((stopId) => route2.stopIds.contains(stopId)).toList();
        if (commonStops.isNotEmpty) {
          final transferStop = commonStops.first;
          
          return [
            RouteSegment(
              type: 'bus',
              routeId: route1.id,
              routeNumber: route1.routeNumber,
              fromStopId: originStopId,
              toStopId: transferStop,
              stopIds: route1.stopIds.sublist(
                route1.stopIds.indexOf(originStopId),
                route1.stopIds.indexOf(transferStop) + 1,
              ),
              estimatedDuration: (route1.stopIds.indexOf(transferStop) - route1.stopIds.indexOf(originStopId)) * 3,
              instructions: 'Take bus ${route1.routeNumber} to ${allStops.firstWhere((s) => s.id == transferStop).name}',
            ),
            RouteSegment(
              type: 'transfer',
              fromStopId: transferStop,
              toStopId: transferStop,
              estimatedDuration: 5,
              instructions: 'Transfer at ${allStops.firstWhere((s) => s.id == transferStop).name}',
            ),
            RouteSegment(
              type: 'bus',
              routeId: route2.id,
              routeNumber: route2.routeNumber,
              fromStopId: transferStop,
              toStopId: destinationStopId,
              stopIds: route2.stopIds.sublist(
                route2.stopIds.indexOf(transferStop),
                route2.stopIds.indexOf(destinationStopId) + 1,
              ),
              estimatedDuration: (route2.stopIds.indexOf(destinationStopId) - route2.stopIds.indexOf(transferStop)) * 3,
              instructions: 'Take bus ${route2.routeNumber} to ${allStops.firstWhere((s) => s.id == destinationStopId).name}',
            ),
          ];
        }
      }
    }

    return [];
  }
}

class RouteSegment {
  final String type; // 'bus', 'walk', 'transfer'
  final String? routeId;
  final String? routeNumber;
  final String fromStopId;
  final String toStopId;
  final List<String>? stopIds;
  final int estimatedDuration; // in minutes
  final String instructions;

  RouteSegment({
    required this.type,
    this.routeId,
    this.routeNumber,
    required this.fromStopId,
    required this.toStopId,
    this.stopIds,
    required this.estimatedDuration,
    required this.instructions,
  });
}

