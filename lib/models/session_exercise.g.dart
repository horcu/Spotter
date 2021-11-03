// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionExerciseAdapter extends TypeAdapter<SessionExercise> {
  @override
  final int typeId = 0;

  @override
  SessionExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionExercise(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as int,
      fields[4] as String,
      fields[5] as String,
      fields[6] as DateTime,
      fields[7] as int,
      fields[8] as bool,
      (fields[9] as List).cast<dynamic>(),
      fields[10] as Part,
      fields[11] as int,
      fields[12] as int,
      fields[13] as double,
      fields[14] as double,
      (fields[15] as List?)?.cast<dynamic>(),
      fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionExercise obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.recommendedWeight)
      ..writeByte(4)
      ..write(obj.lastRep)
      ..writeByte(5)
      ..write(obj.rep)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.lastWeight)
      ..writeByte(8)
      ..write(obj.increased)
      ..writeByte(9)
      ..write(obj.equipment)
      ..writeByte(10)
      ..write(obj.part)
      ..writeByte(11)
      ..write(obj.duration)
      ..writeByte(12)
      ..write(obj.lastDuration)
      ..writeByte(13)
      ..write(obj.distance)
      ..writeByte(14)
      ..write(obj.lastDistance)
      ..writeByte(15)
      ..write(obj.history)
      ..writeByte(16)
      ..write(obj.equipmentUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
