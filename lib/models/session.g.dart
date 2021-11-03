// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 2;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session()
      ..exerciseEntries = (fields[0] as List).cast<SessionExercise>()
      .._lastSession = fields[1] as dynamic
      ..part = (fields[2] as List).cast<Part>()
      ..duration = fields[3] as int
      ..date = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.exerciseEntries)
      ..writeByte(1)
      ..write(obj._lastSession)
      ..writeByte(2)
      ..write(obj.part)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
