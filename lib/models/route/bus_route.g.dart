// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_route.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusRouteAdapter extends TypeAdapter<BusRoute> {
  @override
  final int typeId = 1;

  @override
  BusRoute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusRoute(
      id: fields[0] as String,
      routeNumber: fields[1] as String,
      routeName: fields[2] as String,
      origin: fields[3] as String,
      destination: fields[4] as String,
      stopIds: (fields[5] as List).cast<String>(),
      color: fields[6] as String,
      isActive: fields[7] as bool,
      description: fields[8] as String?,
      estimatedDuration: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BusRoute obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.routeNumber)
      ..writeByte(2)
      ..write(obj.routeName)
      ..writeByte(3)
      ..write(obj.origin)
      ..writeByte(4)
      ..write(obj.destination)
      ..writeByte(5)
      ..write(obj.stopIds)
      ..writeByte(6)
      ..write(obj.color)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.estimatedDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusRouteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BusArrivalAdapter extends TypeAdapter<BusArrival> {
  @override
  final int typeId = 2;

  @override
  BusArrival read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusArrival(
      id: fields[0] as String,
      routeId: fields[1] as String,
      stopId: fields[2] as String,
      scheduledTime: fields[3] as DateTime,
      estimatedTime: fields[4] as DateTime?,
      status: fields[5] as String,
      delayMinutes: fields[6] as int?,
      vehicleId: fields[7] as String?,
      isRealTime: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BusArrival obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.routeId)
      ..writeByte(2)
      ..write(obj.stopId)
      ..writeByte(3)
      ..write(obj.scheduledTime)
      ..writeByte(4)
      ..write(obj.estimatedTime)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.delayMinutes)
      ..writeByte(7)
      ..write(obj.vehicleId)
      ..writeByte(8)
      ..write(obj.isRealTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusArrivalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
