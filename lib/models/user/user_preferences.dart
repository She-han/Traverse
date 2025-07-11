import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 3)
class UserPreferences extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final bool isDarkMode;

  @HiveField(2)
  final bool enableNotifications;

  @HiveField(3)
  final bool enableLocationTracking;

  @HiveField(4)
  final int refreshInterval; // in seconds

  @HiveField(5)
  final String preferredLanguage;

  @HiveField(6)
  final double mapZoomLevel;

  @HiveField(7)
  final bool showTraffic;

  @HiveField(8)
  final bool autoRefreshTimetable;

  @HiveField(9)
  final DateTime lastUpdated;

  UserPreferences({
    required this.userId,
    this.isDarkMode = false,
    this.enableNotifications = true,
    this.enableLocationTracking = true,
    this.refreshInterval = 30,
    this.preferredLanguage = 'en',
    this.mapZoomLevel = 15.0,
    this.showTraffic = false,
    this.autoRefreshTimetable = true,
    required this.lastUpdated,
  });

  factory UserPreferences.defaultPreferences() {
    return UserPreferences(
      userId: 'default',
      lastUpdated: DateTime.now(),
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      userId: json['userId'] as String,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableLocationTracking: json['enableLocationTracking'] as bool? ?? true,
      refreshInterval: json['refreshInterval'] as int? ?? 30,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      mapZoomLevel: (json['mapZoomLevel'] as num?)?.toDouble() ?? 15.0,
      showTraffic: json['showTraffic'] as bool? ?? false,
      autoRefreshTimetable: json['autoRefreshTimetable'] as bool? ?? true,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isDarkMode': isDarkMode,
      'enableNotifications': enableNotifications,
      'enableLocationTracking': enableLocationTracking,
      'refreshInterval': refreshInterval,
      'preferredLanguage': preferredLanguage,
      'mapZoomLevel': mapZoomLevel,
      'showTraffic': showTraffic,
      'autoRefreshTimetable': autoRefreshTimetable,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  UserPreferences copyWith({
    String? userId,
    bool? isDarkMode,
    bool? enableNotifications,
    bool? enableLocationTracking,
    int? refreshInterval,
    String? preferredLanguage,
    double? mapZoomLevel,
    bool? showTraffic,
    bool? autoRefreshTimetable,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableLocationTracking: enableLocationTracking ?? this.enableLocationTracking,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      mapZoomLevel: mapZoomLevel ?? this.mapZoomLevel,
      showTraffic: showTraffic ?? this.showTraffic,
      autoRefreshTimetable: autoRefreshTimetable ?? this.autoRefreshTimetable,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserPreferences(userId: $userId, isDarkMode: $isDarkMode)';
  }
}

@HiveType(typeId: 4)
class FavoriteItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type; // 'stop', 'route', 'journey'

  @HiveField(2)
  final String itemId;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime lastUsed;

  @HiveField(7)
  final int usageCount;

  @HiveField(8)
  final Map<String, dynamic> metadata;

  FavoriteItem({
    required this.id,
    required this.type,
    required this.itemId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.lastUsed,
    this.usageCount = 0,
    this.metadata = const {},
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      type: json['type'] as String,
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsed: DateTime.parse(json['lastUsed'] as String),
      usageCount: json['usageCount'] as int? ?? 0,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'itemId': itemId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed.toIso8601String(),
      'usageCount': usageCount,
      'metadata': metadata,
    };
  }

  FavoriteItem copyWith({
    String? id,
    String? type,
    String? itemId,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? lastUsed,
    int? usageCount,
    Map<String, dynamic>? metadata,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      type: type ?? this.type,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'FavoriteItem(id: $id, type: $type, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

