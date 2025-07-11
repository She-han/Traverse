import 'package:hive/hive.dart';

part 'bus_route.g.dart';

@HiveType(typeId: 1)
class BusRoute extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String routeNumber;

  @HiveField(2)
  final String routeName;

  @HiveField(3)
  final String origin;

  @HiveField(4)
  final String destination;

  @HiveField(5)
  final List<String> stopIds;

  @HiveField(6)
  final String color;

  @HiveField(7)
  final bool isActive;

  @HiveField(8)
  final String? description;

  @HiveField(9)
  final int estimatedDuration; // in minutes

  BusRoute({
    required this.id,
    required this.routeNumber,
    required this.routeName,
    required this.origin,
    required this.destination,
    required this.stopIds,
    required this.color,
    this.isActive = true,
    this.description,
    required this.estimatedDuration,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      id: json['id'] as String,
      routeNumber: json['routeNumber'] as String,
      routeName: json['routeName'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      stopIds: List<String>.from(json['stopIds'] ?? []),
      color: json['color'] as String,
      isActive: json['isActive'] as bool? ?? true,
      description: json['description'] as String?,
      estimatedDuration: json['estimatedDuration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeNumber': routeNumber,
      'routeName': routeName,
      'origin': origin,
      'destination': destination,
      'stopIds': stopIds,
      'color': color,
      'isActive': isActive,
      'description': description,
      'estimatedDuration': estimatedDuration,
    };
  }

  @override
  String toString() {
    return 'BusRoute(id: $id, routeNumber: $routeNumber, routeName: $routeName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusRoute && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@HiveType(typeId: 2)
class BusArrival extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String routeId;

  @HiveField(2)
  final String stopId;

  @HiveField(3)
  final DateTime scheduledTime;

  @HiveField(4)
  final DateTime? estimatedTime;

  @HiveField(5)
  final String status; // 'on_time', 'delayed', 'early', 'cancelled'

  @HiveField(6)
  final int? delayMinutes;

  @HiveField(7)
  final String? vehicleId;

  @HiveField(8)
  final bool isRealTime;

  BusArrival({
    required this.id,
    required this.routeId,
    required this.stopId,
    required this.scheduledTime,
    this.estimatedTime,
    required this.status,
    this.delayMinutes,
    this.vehicleId,
    this.isRealTime = false,
  });

  factory BusArrival.fromJson(Map<String, dynamic> json) {
    return BusArrival(
      id: json['id'] as String,
      routeId: json['routeId'] as String,
      stopId: json['stopId'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      estimatedTime: json['estimatedTime'] != null
          ? DateTime.parse(json['estimatedTime'] as String)
          : null,
      status: json['status'] as String,
      delayMinutes: json['delayMinutes'] as int?,
      vehicleId: json['vehicleId'] as String?,
      isRealTime: json['isRealTime'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeId': routeId,
      'stopId': stopId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'estimatedTime': estimatedTime?.toIso8601String(),
      'status': status,
      'delayMinutes': delayMinutes,
      'vehicleId': vehicleId,
      'isRealTime': isRealTime,
    };
  }

  DateTime get effectiveTime => estimatedTime ?? scheduledTime;

  int get minutesUntilArrival {
    final now = DateTime.now();
    final arrival = effectiveTime;
    return arrival.difference(now).inMinutes;
  }

  @override
  String toString() {
    return 'BusArrival(id: $id, routeId: $routeId, scheduledTime: $scheduledTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusArrival && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

