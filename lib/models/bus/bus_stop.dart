import 'package:hive/hive.dart';
import 'dart:math';

part 'bus_stop.g.dart';

@HiveType(typeId: 0)
class BusStop extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String code;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final List<String> routeIds;

  @HiveField(7)
  final bool isActive;

  @HiveField(8)
  final DateTime? lastUpdated;

  BusStop({
    required this.id,
    required this.name,
    required this.code,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.routeIds,
    this.isActive = true,
    this.lastUpdated,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String?,
      routeIds: List<String>.from(json['routeIds'] ?? []),
      isActive: json['isActive'] as bool? ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'routeIds': routeIds,
      'isActive': isActive,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  double distanceTo(double lat, double lon) {
    const double earthRadius = 6371000; // meters
    double dLat = (lat - latitude) * (pi / 180);
    double dLon = (lon - longitude) * (pi / 180);
    double lat1 = latitude * (pi / 180);
    double lat2 = lat * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  @override
  String toString() {
    return 'BusStop(id: $id, name: $name, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusStop && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
