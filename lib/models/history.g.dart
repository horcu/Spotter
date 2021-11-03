// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final int typeId = 13;

  @override
  History read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History(
      equipment: fields[5] as dynamic,
      date: fields[4] as dynamic,
      distance: fields[2] as dynamic,
      duration: fields[3] as dynamic,
      rep: fields[1] as dynamic,
      weight: fields[0] as dynamic,
      name: fields[6] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.rep)
      ..writeByte(2)
      ..write(obj.distance)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.equipment)
      ..writeByte(6)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
