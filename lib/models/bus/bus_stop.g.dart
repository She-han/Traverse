// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_stop.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusStopAdapter extends TypeAdapter<BusStop> {
  @override
  final int typeId = 0;

  @override
  BusStop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusStop(
      id: fields[0] as String,
      name: fields[1] as String,
      code: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      description: fields[5] as String?,
      routeIds: (fields[6] as List).cast<String>(),
      isActive: fields[7] as bool,
      lastUpdated: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BusStop obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.routeIds)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusStopAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
